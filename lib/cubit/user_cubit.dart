// import 'package:mentalhealthh/authentication/auth.dart';

// class UserState {}

// class UserLoading extends UserState {}

// class UserLoaded extends UserState {
//   final String userName;
//   final String userEmail;
//   final String photoUrl;

//   UserLoaded({
//     required this.userName,
//     required this.userEmail,
//     required this.photoUrl,
//   });
// }

// class UserError extends UserState {
//   final String errorMessage;

//   UserError(this.errorMessage);
// }

// class UserCubit extends Cubit<UserState> {
//   UserCubit() : super(UserLoading());

//   Future<void> loadUserData() async {
//     try {
//       String? retrievedUserName = await Auth.getUserName();
//       String? retrievedUserEmail = await Auth.getEmail();
//       String? retrievedPhotoUrl = await Auth.getPhotoUrl();

//       emit(UserLoaded(
//         userName: retrievedUserName ?? '',
//         userEmail: retrievedUserEmail ?? '',
//         photoUrl: retrievedPhotoUrl ?? '',
//       ));
//     } catch (error) {
//       emit(UserError('Failed to load user data'));
//     }
//   }

//   Future<void> updateUserData() async {
//     try {
//       String? retrievedUserName = await Auth.getUserName();
//       String? retrievedUserEmail = await Auth.getEmail();
//       String? retrievedPhotoUrl = await Auth.getPhotoUrl();

//       emit(UserLoaded(
//         userName: retrievedUserName ?? '',
//         userEmail: retrievedUserEmail ?? '',
//         photoUrl: retrievedPhotoUrl ?? '',
//       ));
//     } catch (error) {
//       emit(UserError('Failed to update user data'));
//     }
//   }
// }
