import Foundation

enum GFError: String, Error {
    case invalidUsername = "This username created an invalid request. Please try again."
    case unableToCompleteRequest = "Unable to complete your request. Please check your internet connection."
    case invalidResponseFromServer = "Invalid response from the server."
    case invalidDataFromServer = "The data received from the server was invalid."
    
    case unableToFavourite = "There was an error favouriting this user."
    case alreadyFavourited = "This user has already been favourited."
}
