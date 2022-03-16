import 'package:gsheets/gsheets.dart';

class GoogleSheetsApi {
  // create credentials
  static const _credentials = r'''
  {
   
   {
  "type": "service_account",
  "project_id": "expense-tracker-flutter-344203",
  "private_key_id": "309b45a2edbc70851ae99c674f62f35703139599",
  "private_key": "-----BEGIN PRIVATE KEY-----\nMIIEvAIBADANBgkqhkiG9w0BAQEFAASCBKYwggSiAgEAAoIBAQClyCceBDNAMduM\nIpozFQARHOGRLTE5Hf1sQnDle+v6iGzKQPE/HdaVTbPT4Lc2cEqiiyYI16OLC4io\nNJqcI7V0QPG0cH4gD304FWG1pXQlcK3Epdb+GqQxzYnRprIyZllhW08oA3X3RITe\n8ayTwBxUb7q7dD4OgKa92dZDlZsTWlYteM/vYPvAaSyHsxPcPEqg/8VSkI6QL1C4\nJMwKALwBfKpSoDYNUQyIO6Gtpbggi06lwhNbX62fHn9wkIzoGGkbmCx87KN2w9Sh\niSLNslVbwQh5l6aSF/5uVhBEYpxuE7bbLRh5AE0RxuvEAYYpqzb4pWWuX1489xM3\ngUAQlwrDAgMBAAECggEAI4u693CnHIiULoPs1C8YiJLMurgZ6clIYUINuubLPjiq\nOuOZ1pKrQ/AZMsDoB8AkAJ4dVaAG7PVYI9jDnd76NScHrEzCflVT4AaVoMENGkoC\nuDtm0a0cr6EGf/FiG/ReDcXqPwYe8Rm786GWA0gZyvD59N+DvtBO8D4Y9vzI92j6\nwL00b3J9+IVrGE3JH3Qq77LPJ+WfeNkJLHgP2YTK+J4nzZJVjKNDAVqPktePkH9z\n8TDupV8afNTdbyaYjQ0arh7m8UGz/d3gXIwAgEy1QRF+dFbPyyQt51aWu6klSt/0\nG9xBc4SGYRuafjP+NmKM5LEb0bD7jKh3Gc4tOy6gwQKBgQDZXm6Nd8kKBWmFp0xd\nGGPCBE1fApJaa2XMMRvNY2PIGdel/Rj/DU94mOP5J7DZfMpKOGT408udhDVqVfxH\nMgre/slEFiZNGAi7O3cH6LZwYf8gFVlTh6WbYi1+pbcMqAdXF44cyeXKnIYs71Od\nNipbugqX0XsLWVaUzN6dJ0Iv2wKBgQDDPq5Yrmm3q1edlyYM4JtZr1ICuEJHHkrU\nOOTFfYBgwA3x+auYFaJpzbhFGZyBN2kywx5KcAI/i80hkI8H7AVh+V0P5TI9BLMd\nlMZx01OtV35v09xPEfQB6ut21bDdKdxMBOhqFukRVKSWbTp5DI63HR6xiZWZZklX\n02b4uuoZOQKBgBFNrB1E2NMcZS8Hh1Ot2lsafpI+oSnjfMIJcr4h2FKYhAspn7DF\n/XqLKTKvTyuw/GV2IcuRCJdsa9ggKin8uNLRk3IBFWFztVY6QJp3kvZVRrrmGCtH\nFA7PfPGk/XJbeeIb9Osjw1Air6eqEYzlP+/3WlqFiXb40KSdvmbiNimbAoGAFqve\nntmR2QwCXoBAoNor79wVz88JkyyHT+FTX0NVduaWN/Tf4gcRFuwWa5+vtqlyg7x4\ndfhPqoVXSoB4u1jCvz+veLsKfF9hVRwDdxAs9UHloqKdQGk7RkW7Fc92fBfyRrmD\nK16BrcuAWR9R3OCCaezttXvebTOdbJ9Vo6hAqrECgYAbvY1NzAIyf6NxjN6D90Xt\nDliF3jleKgcbe5kjUOOBMSF9UCD30rD8cUB66dafouOItTfsz/wR5s2zSG4rmPQ0\nLuChsRlQE6qfGXvIQH84V7LPhSR9we4DH0mD1leZsuXF+6NuAnKBPfJZaC6vOO4k\nR6+T2BBs8IZoCbIcs9V1OQ==\n-----END PRIVATE KEY-----\n",
  "client_email": "expense-tracker-flutter@expense-tracker-flutter-344203.iam.gserviceaccount.com",
  "client_id": "108423410267190285310",
  "auth_uri": "https://accounts.google.com/o/oauth2/auth",
  "token_uri": "https://oauth2.googleapis.com/token",
  "auth_provider_x509_cert_url": "https://www.googleapis.com/oauth2/v1/certs",
  "client_x509_cert_url": "https://www.googleapis.com/robot/v1/metadata/x509/expense-tracker-flutter%40expense-tracker-flutter-344203.iam.gserviceaccount.com"
}

  
  }
  ''';

  // set up & connect to the spreadsheet
  static final _spreadsheetId = '1UpzJoXSvjBL8u-4LMwpReDSlyow646FTabLuUn9mqgg';
  static final _gsheets = GSheets(_credentials);
  static Worksheet? _worksheet;

  // some variables to keep track of..
  static int numberOfTransactions = 0;
  static List<List<dynamic>> currentTransactions = [];
  static bool loading = true;

  // initialise the spreadsheet!
  Future init() async {
    final ss = await _gsheets.spreadsheet(_spreadsheetId);
    _worksheet = ss.worksheetByTitle('Worksheet1');
    countRows();
  }

  // count the number of notes
  static Future countRows() async {
    while ((await _worksheet!.values
            .value(column: 1, row: numberOfTransactions + 1)) !=
        '') {
      numberOfTransactions++;
    }
    // now we know how many notes to load, now let's load them!
    loadTransactions();
  }

  // load existing notes from the spreadsheet
  static Future loadTransactions() async {
    if (_worksheet == null) return;

    for (int i = 1; i < numberOfTransactions; i++) {
      final String transactionName =
          await _worksheet!.values.value(column: 1, row: i + 1);
      final String transactionAmount =
          await _worksheet!.values.value(column: 2, row: i + 1);
      final String transactionType =
          await _worksheet!.values.value(column: 3, row: i + 1);

      if (currentTransactions.length < numberOfTransactions) {
        currentTransactions.add([
          transactionName,
          transactionAmount,
          transactionType,
        ]);
      }
    }
    print(currentTransactions);
    // this will stop the circular loading indicator
    loading = false;
  }

  // insert a new transaction
  static Future insert(String name, String amount, bool _isIncome) async {
    if (_worksheet == null) return;
    numberOfTransactions++;
    currentTransactions.add([
      name,
      amount,
      _isIncome == true ? 'income' : 'expense',
    ]);
    await _worksheet!.values.appendRow([
      name,
      amount,
      _isIncome == true ? 'income' : 'expense',
    ]);
  }

  // CALCULATE THE TOTAL INCOME!
  static double calculateIncome() {
    double totalIncome = 0;
    for (int i = 0; i < currentTransactions.length; i++) {
      if (currentTransactions[i][2] == 'income') {
        totalIncome += double.parse(currentTransactions[i][1]);
      }
    }
    return totalIncome;
  }

  // CALCULATE THE TOTAL EXPENSE!
  static double calculateExpense() {
    double totalExpense = 0;
    for (int i = 0; i < currentTransactions.length; i++) {
      if (currentTransactions[i][2] == 'expense') {
        totalExpense += double.parse(currentTransactions[i][1]);
      }
    }
    return totalExpense;
  }
}