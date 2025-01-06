/// A sealed class containing constants for network-related endpoints.
sealed class NetworkConstants {
  const NetworkConstants();

  /// The authority for the network requests.
  static const authority = 'localhost:3000';

  /// The base API path.
  static const _api = '/api/v1';

  /// Endpoint to get all blocks.
  static const getAllBlocksEndpoint = '$_api/blocks';

  /// Returns the endpoint to get a block by its ID.
  ///
  /// [id] - The ID of the block.
  static String getBlockByIdEndpoint(String id) => '$getAllBlocksEndpoint/$id';

  /// Returns the endpoint to get all rooms in a block by the block's ID.
  ///
  /// [id] - The ID of the block.
  static String getBlockRoomsEndpoint(String id) =>
      '${getBlockByIdEndpoint(id)}/classes';

  /// Endpoint to get all rooms.
  static const getAllRoomsEndpoint = '$_api/rooms';

  /// Returns the endpoint to get a room by its ID.
  ///
  /// [id] - The ID of the room.
  static String getRoomByIdEndpoint(String id) => '$getAllRoomsEndpoint/$id';

  /// Returns the endpoint to get all bookings for a room by the room's ID.
  ///
  /// [id] - The ID of the room.
  static String getRoomBookingsEndpoint(String id) =>
      '${getRoomByIdEndpoint(id)}/bookings';

  /// Endpoint to book a class.
  static const bookRoomEndpoint = '$_api/bookings';

  /// Returns the endpoint to cancel a booking by its ID.
  ///
  /// [id] - The ID of the booking.
  static String cancelBookingEndpoint(String id) => '$bookRoomEndpoint/$id';

  /// Endpoint to update a booking by its ID.
  ///
  /// [id] - The ID of the booking.
  static String updateBookingEndpoint(String id) => '$bookRoomEndpoint/$id';

  /// Returns the endpoint to get all bookings for a representative
  static String getUserBookingsEndpoint = bookRoomEndpoint;
}
