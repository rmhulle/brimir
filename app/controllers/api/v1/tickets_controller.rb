# Brimir is a helpdesk system to handle email support requests.
# Copyright (C) 2012-2015 Ivaldi https://ivaldi.nl/
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU Affero General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU Affero General Public License for more details.
#
# You should have received a copy of the GNU Affero General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.
class Api::V1::TicketsController < Api::V1::ApplicationController
  include TicketsapiStrongParams

  load_and_authorize_resource :ticket

  def index
    if current_user.agent && params.has_key?(:user_email)
      user= User.find_by( email: Base64.urlsafe_decode64(params[:user_email]) )
      @tickets = Ticket.by_status(:open).viewable_by(user)
    else
      @tickets = Ticket.by_status(:open).viewable_by(current_user)
    end
  end

  def show
    @ticket = Ticket.find(params[:id])
  end

  def create

    incoming = Ticket.create(ticket_params)
    @ticket = incoming

    base64image = ticket_params[:attachments_attributes][:"123456"][:file]
    imageDataString = splitBase64(base64image)[:data]
    imageDataBinary = Base64.decode64(imageDataString)

    file = StringIO.new(imageDataBinary)
    file.class.class_eval {
        attr_accessor :original_filename, :content_type
    }
    file.original_filename = 'upload.png'
    file.content_type = 'image/png'
    content_id = 0

    teste = incoming.attachments.create(file: file,
        content_id: content_id)

    if teste
      NotificationMailer.incoming_message(@ticket, params[:message])
      render nothing: true, status: :created
    else
      render nothing: true, status: :bad_request
    end
  end

  def splitBase64(uri)
    if uri.match(%r{^data:(.*?);(.*?),(.*)$})
      return {
        type:      $1, # "image/png"
        encoder:   $2, # "base64"
        data:      $3, # data string
        extension: $1.split('/')[1] # "png"
        }
    end
  end
end
