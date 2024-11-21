import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'l10n/messages_all_locales.dart';


class AppLocalizations {
  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static Future<AppLocalizations> load(Locale locale) async {
    final String name = locale.countryCode == null || locale.countryCode!.isEmpty
        ? locale.languageCode
        : locale.toString();
    final String localeName = Intl.canonicalizedLocale(name);

    await initializeMessages(localeName);
    Intl.defaultLocale = localeName;

    return AppLocalizations();
  }

  // Authentication Messages
  String get welcomeBack => Intl.message('Welcome Back!',
      name: 'welcomeBack');

  String get loginToYourAccount => Intl.message('Login to your account',
      name: 'loginToYourAccount');

  String get email => Intl.message('Email',
      name: 'email');

  String get password => Intl.message('Password',
      name: 'password');

  String get forgotPassword => Intl.message('Forgot Password?',
      name: 'forgotPassword');

  String get login => Intl.message('Login',
      name: 'login');

  String get dontHaveAnAccountSignUp => Intl.message("Don't have an account?, Sign Up",
      name: 'dontHaveAnAccountSignUp');

  // Registration Messages
  String get createAccount => Intl.message('Create Account',
      name: 'createAccount');

  String get signUpToGetStarted => Intl.message('Sign up to get started',
      name: 'signUpToGetStarted');

  String get name => Intl.message('Name',
      name: 'name');

  String get age => Intl.message('Age',
      name: 'age');

  String get gender => Intl.message('Gender',
      name: 'gender');

  String get education => Intl.message('Education',
      name: 'education');

  String get occupation => Intl.message('Occupation',
      name: 'occupation');

  String get howLongHaveYouHadHypertension =>
      Intl.message('How long have you had hypertension?',
          name: 'howLongHaveYouHadHypertension');

  String get phone => Intl.message('Phone',
      name: 'phone');

  String get bloodPressure => Intl.message('Blood Pressure',
      name: 'bloodPressure');

  String get signUp => Intl.message('Sign Up',
      name: 'signUp');

  String get alreadyHaveAnAccountLogin =>
      Intl.message('Already have an account?, Login',
          name: 'alreadyHaveAnAccountLogin');

  // Menu and General Messages
  String get log => Intl.message('Log',
      name: 'log');

  String get diseaseMenu => Intl.message('Disease Menu',
      name: 'diseaseMenu');

  String get disease => Intl.message('Disease',
      name: 'disease');

  String get diseaseInformation => Intl.message('Disease Information',
      name: 'diseaseInformation');

  String get exit => Intl.message('Exit',
      name: 'exit');

  String get confirmExit => Intl.message('Confirm Exit',
      name: 'confirmExit');

  String get areYouSureYouWantToExit =>
      Intl.message('Are you sure you want to exit?',
          name: 'areYouSureYouWantToExit');

  String get cancel => Intl.message('Cancel',
      name: 'cancel');

  String get yes => Intl.message('Yes',
      name: 'yes');
  String get registrationSuccess => Intl.message(
    'Registration successful',
    name: 'registrationSuccess',
  );

  String get allFieldsRequired => Intl.message(
    'All fields are required',
    name: 'allFieldsRequired',
  );

  String get passwordsDoNotMatch => Intl.message(
    'Passwords do not match',
    name: 'passwordsDoNotMatch',
  );

  String get notificationSettings => Intl.message(
    'Notification Settings',
    name: 'notificationSettings',
  );

  String get username => Intl.message(
    'Username',
    name: 'username',
  );

  String get confirmPassword => Intl.message(
    'Confirm Password',
    name: 'confirmPassword',
  );

  String get dateOfBirth => Intl.message(
    'Date of Birth (YYYY-MM-DD)',
    name: 'dateOfBirth',
  );

  String get physicalActivityName => Intl.message(
    'Physical Activity Name',
    name: 'physicalActivityName',
  );

  String get physicalActivityTime => Intl.message(
    'Physical Activity Time',
    name: 'physicalActivityTime',
  );

  String get medicine => Intl.message(
    'Medicine',
    name: 'medicine',
  );

  String get medicineName => Intl.message(
    'Medicine Name',
    name: 'medicineName',
  );

  String get timesPerDay => Intl.message(
    'Times per day',
    name: 'timesPerDay',
  );

  String get times => Intl.message(
    'times',
    name: 'times',
  );

  String get male => Intl.message(
    'Male',
    name: 'male',
  );

  String get female => Intl.message(
    'Female',
    name: 'female',
  );

  String get bloodPressureNote => Intl.message(
    'Blood pressure initial note',
    name: 'bloodPressureNote',
  );

  String get alreadyHaveAccount => Intl.message(
    'Already have an account? Login',
    name: 'alreadyHaveAccount',
  );
  String get breakfast => Intl.message('Breakfast', name: 'breakfast');
  String get lunch => Intl.message('Lunch', name: 'lunch');
  String get dinner => Intl.message('Dinner', name: 'dinner');
  String get snacks => Intl.message('Snacks', name: 'snacks');
  String get kcal => Intl.message('kcal', name: 'kcal');
  String get totalCaloriesConsumed => Intl.message('Total Calories Consumed', name: 'totalCaloriesConsumed');
  String get other => Intl.message('Other', name: 'other');
  String get exercise => Intl.message('Exercise', name: 'exercise');
  String get water => Intl.message('Water', name: 'water');
  String get oz => Intl.message('oz', name: 'oz');
  String get notes => Intl.message('Notes', name: 'notes');
  String get noNotesYet => Intl.message('No notes yet', name: 'noNotesYet');
  String get menu => Intl.message('Ht.Co (Hypertension Control)', name: 'menu');
  String get knowledge => Intl.message('Knowledge', name: 'knowledge');
  String get recipe => Intl.message('Recipe', name: 'recipe');
  String get manage => Intl.message('Manage', name: 'manage');
  String get summary =>Intl.message('Summary', name: 'summary');
  String get chat => Intl.message('Chat', name: 'chat');
  String get reminder => Intl.message('Reminder', name: 'reminder');
  String get exitConfirmTitle =>Intl.message('Confirm Exit', name: 'exitConfirmTitle');
  String get exitConfirmMessage => Intl.message('Are you sure you want to exit and return to login page?', name: 'exitConfirmMessage');
  String get diseases => Intl.message('Diseases', name: 'diseases');
  String get selfManagement => Intl.message('Self Management', name: 'selfManagement');
  String get addFood => Intl.message(
    'Add Food',
    name: 'addFood',
  );

  String get foodName => Intl.message(
    'Food name',
    name: 'foodName',
  );

  String get calories => Intl.message(
    'Calories',
    name: 'calories',
  );

  String get recommendedPortionTable => Intl.message(
    'Recommended Portion Table',
    name: 'recommendedPortionTable',
  );

  String get addMenu => Intl.message(
    'Add Menu',
    name: 'addMenu',
  );
  String searchMeal(String mealType) => Intl.message(
    'Search $mealType',
    name: 'searchMeal',
    args: [mealType],
    desc: 'Title for search meal page',
  );

  String get searchFood => Intl.message(
    'Search food...',
    name: 'searchFood',
  );

  String noRecipesFor(String mealType) => Intl.message(
    'No recipes for $mealType',
    name: 'noRecipesFor',
    args: [mealType],
    desc: 'Message shown when no recipes are available for a meal type',
  );

  String get noSearchResults => Intl.message(
    'No search results',
    name: 'noSearchResults',
  );

  String get fat => Intl.message(
    'Fat',
    name: 'fat',
  );

  String get totalCarbs => Intl.message(
    'Total Carbs',
    name: 'totalCarbs',
  );

  String get protein => Intl.message(
    'Protein',
    name: 'protein',
  );

  String get addRecipe => Intl.message(
    'Add Recipe +',
    name: 'addRecipe',
  );

  String get createRecipe => Intl.message(
    'Create Recipe +',
    name: 'createRecipe',
  );

  String get recipeAddedSuccessfully => Intl.message(
    'Recipe added successfully',
    name: 'recipeAddedSuccessfully',
  );

  String get exerciseInstructions => Intl.message(
    'Enter your weight, exercise duration, and the activity to estimate your energy expenditure',
    name: 'exerciseInstructions',
  );

  String get weightInKg => Intl.message(
    'Weight (kg)',
    name: 'weightInKg',
  );

  String get enterWeightInKg => Intl.message(
    'Enter weight in kg',
    name: 'enterWeightInKg',
  );

  String get durationInMinutes => Intl.message(
    'Duration (minutes)',
    name: 'durationInMinutes',
  );

  String get enterDurationInMinutes => Intl.message(
    'Enter duration in minutes',
    name: 'enterDurationInMinutes',
  );

  String get distanceInMeters => Intl.message(
    'Distance (meters)',
    name: 'distanceInMeters',
  );

  String get enterDistanceInMeters => Intl.message(
    'Enter distance in meters',
    name: 'enterDistanceInMeters',
  );

  String get exerciseType => Intl.message(
    'Exercise Type',
    name: 'exerciseType',
  );

  String get calculateAndAdd => Intl.message(
    'Calculate and Add',
    name: 'calculateAndAdd',
  );

  String caloriesBurnedFormat(double calories) => Intl.message(
    'Calories Burned: ${calories} kCal',
    name: 'caloriesBurnedFormat',
    args: [calories],
  );

  String get notAuthenticated => Intl.message(
    'Not authenticated',
    name: 'notAuthenticated',
  );

  String get failedToAddExercise => Intl.message(
    'Failed to add exercise',
    name: 'failedToAddExercise',
  );

  // Exercise types
  String get rowingMachineIntense => Intl.message(
    'Rowing Machine (Intense)',
    name: 'rowingMachineIntense',
  );

  String get lowImpactExercise => Intl.message(
    'Low Impact Exercise',
    name: 'lowImpactExercise',
  );

  String get running => Intl.message(
    'Running',
    name: 'running',
  );

  String get cycling => Intl.message(
    'Cycling',
    name: 'cycling',
  );

  String get swimming => Intl.message(
    'Swimming',
    name: 'swimming',
  );

  String get walking => Intl.message(
    'Walking',
    name: 'walking',
  );

  String get waterIntake => Intl.message(
    'Water Intake',
    name: 'waterIntake',
  );

  String get enterWaterConsumed => Intl.message(
    'Enter the amount of water consumed (in ml):',
    name: 'enterWaterConsumed',
  );

  String get enterWaterInMl => Intl.message(
    'Enter water in ml',
    name: 'enterWaterInMl',
  );

  String get addWaterIntake => Intl.message(
    'Add Water Intake',
    name: 'addWaterIntake',
  );

  String get failedToAddWaterIntake => Intl.message(
    'Failed to add water intake',
    name: 'failedToAddWaterIntake',
  );
  String get bloodPressureTitle => Intl.message(
    'Blood Pressure',
    name: 'bloodPressureTitle',
  );

  String get checkBloodPressure => Intl.message(
    'Check your blood pressure!',
    name: 'checkBloodPressure',
  );

  String get systolic => Intl.message(
    'Systolic',
    name: 'systolic',
  );

  String get diastolic => Intl.message(
    'Diastolic',
    name: 'diastolic',
  );

  String get save => Intl.message(
    'Save',
    name: 'save',
  );

  String get enterValidNumbers => Intl.message(
    'Please enter valid numbers',
    name: 'enterValidNumbers',
  );

  String get failedToSaveBloodPressure => Intl.message(
    'Failed to save blood pressure',
    name: 'failedToSaveBloodPressure',
  );

  // Notes
  String get noteTitle => Intl.message(
    'Title:',
    name: 'noteTitle',
  );

  String get noteContent => Intl.message(
    'Content:',
    name: 'noteContent',
  );

  String get enterNoteTitle => Intl.message(
    'Enter note title',
    name: 'enterNoteTitle',
  );

  String get enterNoteContent => Intl.message(
    'Enter your note',
    name: 'enterNoteContent',
  );

  String get addNote => Intl.message(
    'Add Note',
    name: 'addNote',
  );

  String get fillAllFields => Intl.message(
    'Please fill in all fields',
    name: 'fillAllFields',
  );

  String get failedToAddNote => Intl.message(
    'Failed to add note',
    name: 'failedToAddNote',
  );
  String get usageRules => Intl.message(
    'Usage Rules:',
    name: 'usageRules',
  );

  String get description => Intl.message(
    'Description:',
    name: 'description',
  );

  String get indications => Intl.message(
    'Indications:',
    name: 'indications',
  );

  String get warnings => Intl.message(
    'Warnings:',
    name: 'warnings',
  );

  String get add => Intl.message(
    'ADD',
    name: 'add',
  );

  String get medicineAddedSuccessfully => Intl.message(
    'Medicine added successfully',
    name: 'medicineAddedSuccessfully',
  );

  String get failedToAddMedicine => Intl.message(
    'Failed to add medicine',
    name: 'failedToAddMedicine',
  );

  // Recipe Card
  String get portion => Intl.message(
    'portion',
    name: 'portion',
  );

  String get noName => Intl.message(
    'No Name',
    name: 'noName',
  );

  String get noDescriptionAvailable => Intl.message(
    'No description available',
    name: 'noDescriptionAvailable',
  );

  String get carbs => Intl.message(
    'Carbs',
    name: 'carbs',
  );

  String get cal => Intl.message(
    'Cal',
    name: 'cal',
  );

  String get cholesterol => Intl.message(
    'Cholesterol',
    name: 'cholesterol',
  );

  // Home Add Obat
  String get recordDailyMedicines => Intl.message(
    'Record daily medicines!',
    name: 'recordDailyMedicines',
  );

  String get addMedicine => Intl.message(
  'Add Medicine',
  name: 'addMedicine',);

  String get dailyRecap => Intl.message(
    'Daily Recap',
    name: 'dailyRecap',
  );

  String get foodNotes => Intl.message(
    'Food Notes:',
    name: 'foodNotes',
  );

  String get drinkNotes => Intl.message(
    'Drink Notes:',
    name: 'drinkNotes',
  );

  String get physicalActivity => Intl.message(
    'Physical Activity:',
    name: 'physicalActivity',
  );

  String get bloodPressureNotes => Intl.message(
    'Blood Pressure:',
    name: 'bloodPressureNotes',
  );

  String get medicineTaken => Intl.message(
    'Medicine Taken:',
    name: 'medicineTaken',
  );

  String get totalCaloriesFormat => Intl.message(
    'Total Calories: {calories}',
    name: 'totalCaloriesFormat',
    args: [calories],
    desc: 'Format for displaying total calories',
  );

  String get addRecipePage => Intl.message(
    'Add Recipe',
    name: 'addRecipePage',
  );

  String get enterNameAndDescription => Intl.message(
    'Please enter food name and description',
    name: 'enterNameAndDescription',
  );

  String get carbohydrate => Intl.message(
    'Carbohydrate',
    name: 'carbohydrate',
  );

  String get sugar => Intl.message(
    'Sugar',
    name: 'sugar',
  );

  String get cholesterolInMg => Intl.message(
    'Cholesterol (mg)',
    name: 'cholesterolInMg',
  );

  String get weightInG => Intl.message(
    'Weight (g)',
    name: 'weightInG',
  );

  String get noFileChosen => Intl.message(
    'No file chosen',
    name: 'noFileChosen',
  );

  String get chooseFile => Intl.message(
    'Choose File',
    name: 'chooseFile',
  );

  String get reminderDelay => Intl.message(
    'Set notifications only after 21 days from account creation',
    name: 'reminderDelay',
  );

  String get enterReminderMessage => Intl.message(
    'Enter reminder message',
    name: 'enterReminderMessage',
  );

  String addReminderFor(String type) => Intl.message(
    'Add Reminder for $type',
    name: 'addReminderFor',
    args: [type],
    desc: 'Title for add reminder page with type',
  );

  String get selectTime => Intl.message(
    'Select Time',
    name: 'selectTime',
  );

  String timeFormat(String time) => Intl.message(
    'Time: $time',
    name: 'time',
    args: [time],
  );

  String get selectDate => Intl.message(
    'Select Date',
    name: 'selectDate',
  );

  String dateFormat(String date) => Intl.message(
    'Date: $date',
    name: 'date',
    args: [date],
  );

  String get reminderMessage => Intl.message(
    'Reminder Message',
    name: 'reminderMessage',
  );

  String get saveReminder => Intl.message(
    'Save Reminder',
    name: 'saveReminder',
  );

  String get reminderAddedSuccessfully => Intl.message(
    'Reminder added successfully',
    name: 'reminderAddedSuccessfully',
  );

  String get failedToAddReminder => Intl.message(
    'Failed to add reminder',
    name: 'failedToAddReminder',
  );

  String get addReminder => Intl.message(
    'Add Reminder',
    name: 'addReminder',
  );

  String get breakfastpic => Intl.message('🍳 Breakfast', name: 'breakfastpic');
  String get lunchpic => Intl.message('🥗 Lunch', name: 'lunchpic');
  String get dinnerpic => Intl.message('🥣 Dinner', name: 'dinnerpic');
  String get snackspic => Intl.message('🍪 Snacks', name: 'snackspic');
  String get drinkpic => Intl.message('🥤 Drink', name: 'drinkpic');
  String get physicalActivitypic => Intl.message('🏃 Physical Activity', name: 'physicalActivitypic');
  String get takeMedicinepic => Intl.message('💊 Take Medicine', name: 'takeMedicinepic');
  String get readKnowledgepic => Intl.message('📚 Read Knowledge', name: 'readKnowledgepic');

  String get foodType => Intl.message(
    'Food Type',
    name: 'foodType',
  );

  String get foodNameRequired => Intl.message(
    'Please enter food name',
    name: 'foodNameRequired',
  );

  String get descriptionRequired => Intl.message(
    'Please enter description',
    name: 'descriptionRequired',
  );

  String get portionRequired => Intl.message(
    'Please enter portion',
    name: 'portionRequired',
  );
  String get caloriesRequired => Intl.message(
    'Please enter portion',
    name: 'caloriesRequired',
  );

  String get fatRequired => Intl.message(
    'Please enter fat content',
    name: 'fatRequired',
  );

  String get proteinRequired => Intl.message(
    'Please enter protein content',
    name: 'proteinRequired',
  );

  String get enterValidNumber => Intl.message(
    'Please enter a valid number',
    name: 'enterValidNumber',
  );

  String get enterNonNegativeNumber => Intl.message(
    'Please enter a non-negative number',
    name: 'enterNonNegativeNumber',
  );

  String get carbRequired => Intl.message('Please enter carbohydrate content', name: 'carbRequired');
  String get sugarRequired => Intl.message('Please enter sugar content', name: 'sugarRequired');
  String get cholesterolRequired => Intl.message('Please enter cholesterol content', name: 'cholesterolRequired');
  String get weightRequired => Intl.message('Please enter weight content', name: 'weightRequired');
  String get usernameRequired => Intl.message(
    'Username is required',
    name: 'usernameRequired',
  );

  String get usernameTooShort => Intl.message(
    'Username must be at least 4 characters',
    name: 'usernameTooShort',
  );

  String get passwordRequired => Intl.message(
    'Password is required',
    name: 'passwordRequired',
  );

  String get passwordTooShort => Intl.message(
    'Password must be at least 6 characters',
    name: 'passwordTooShort',
  );

  String get confirmPasswordRequired => Intl.message(
    'Please confirm your password',
    name: 'confirmPasswordRequired',
  );

  String get birthDateRequired => Intl.message(
    'Birth date is required',
    name: 'birthDateRequired',
  );

  String get invalidDateFormat => Intl.message(
    'Invalid date format (YYYY-MM-DD)',
    name: 'invalidDateFormat',
  );

  String get phoneRequired => Intl.message(
    'Phone number is required',
    name: 'phoneRequired',
  );

  String get invalidPhoneFormat => Intl.message(
    'Invalid phone number format',
    name: 'invalidPhoneFormat',
  );

  String get durationRequired => Intl.message(
    'Duration is required',
    name: 'durationRequired',
  );

  String get invalidNumberFormat => Intl.message(
    'Please enter a valid number',
    name: 'invalidNumberFormat',
  );

  String get registrationFailed => Intl.message(
    'Registration failed. Please try again.',
    name: 'registrationFailed',
  );

  String get unexpectedError => Intl.message(
    'An unexpected error occurred. Please try again.',
    name: 'unexpectedError',
  );

  String get nameRequired => Intl.message(
    'Name is required',
    name: 'nameRequired',
  );
  String get nameTooShort => Intl.message(
    'Name must be at least 3 characters',
    name: 'nameTooShort',
  );
  String get educationRequired => Intl.message(
    'Education is required',
    name: 'educationRequired',
  );

  String get occupationRequired => Intl.message(
    'Occupation is required',
    name: 'occupationRequired',
  );

  String get medicineNameRequired => Intl.message(
    'Medicine name is required',
    name: 'medicineNameRequired',
  );

  String get bloodPressureNoteRequired => Intl.message(
    'Blood pressure note is required',
    name: 'bloodPressureNoteRequired',
  );

  String get bloodPressureNoteTooShort => Intl.message(
    'Blood pressure note must be at least 10 characters',
    name: 'bloodPressureNoteTooShort',
  );

  String get exerciseTypeRequired => Intl.message(
    'Please select exercise type',
    name: 'exerciseTypeRequired',
  );

  String get medicineCountRequired => Intl.message(
    'Please select medicine count',
    name: 'medicineCountRequired',
  );
  String get noDataAvailable => Intl.message(
    'No data available',
    name: 'noDataAvailable',
  );

  get required => null;


}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) {
    return ['en', 'id'].contains(locale.languageCode);
  }

  @override
  Future<AppLocalizations> load(Locale locale) {
    return AppLocalizations.load(locale);
  }

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}