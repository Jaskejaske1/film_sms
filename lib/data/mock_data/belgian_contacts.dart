import '../models/contact.dart';
import '../../core/constants/belgian_constants.dart';

class BelgianContactsData {
  static List<Contact> getAllContacts() {
    return [
      // Transport & Services (Dynamic)
      Contact(
        name: 'De Lijn',
        phoneNumber: BelgianConstants.deLijnNumber,
        type: ContactType.transport,
        isDynamic: true,
      ),

      // Family (8 contacts)
      Contact(
        name: 'Mama',
        phoneNumber: '+32 468 123 456',
        type: ContactType.family,
      ),
      Contact(
        name: 'Papa',
        phoneNumber: '+32 477 234 567',
        type: ContactType.family,
      ),
      Contact(
        name: 'Zus Emma',
        phoneNumber: '+32 465 345 678',
        type: ContactType.family,
      ),
      Contact(
        name: 'Broer Tom',
        phoneNumber: '+32 471 456 789',
        type: ContactType.family,
      ),
      Contact(
        name: 'Oma Mie',
        phoneNumber: '+32 468 567 890',
        type: ContactType.family,
      ),
      Contact(
        name: 'Opa Jan',
        phoneNumber: '+32 477 678 901',
        type: ContactType.family,
      ),
      Contact(
        name: 'Tante Lies',
        phoneNumber: '+32 465 789 012',
        type: ContactType.family,
      ),
      Contact(
        name: 'Oom Karel',
        phoneNumber: '+32 471 890 123',
        type: ContactType.family,
      ),

      // Work (5 contacts)
      Contact(
        name: 'Baas - Dirk Vermeulen',
        phoneNumber: '+32 468 234 567',
        type: ContactType.work,
      ),
      Contact(
        name: 'Sarah (HR)',
        phoneNumber: '+32 477 345 678',
        type: ContactType.work,
      ),
      Contact(
        name: 'Luc (Collega)',
        phoneNumber: '+32 465 456 789',
        type: ContactType.work,
      ),
      Contact(
        name: 'Martine (Project)',
        phoneNumber: '+32 471 567 890',
        type: ContactType.work,
      ),
      Contact(
        name: 'IT Support',
        phoneNumber: '+32 468 678 901',
        type: ContactType.work,
      ),

      // Friends (4 contacts)
      Contact(
        name: 'Lisa',
        phoneNumber: '+32 477 789 012',
        type: ContactType.friends,
      ),
      Contact(
        name: 'Matthias',
        phoneNumber: '+32 465 890 123',
        type: ContactType.friends,
      ),
      Contact(
        name: 'Sofie',
        phoneNumber: '+32 471 901 234',
        type: ContactType.friends,
      ),
      Contact(
        name: 'Kevin',
        phoneNumber: '+32 468 012 345',
        type: ContactType.friends,
      ),

      // Services (4 contacts)
      Contact(
        name: 'NMBS',
        phoneNumber: '+32 2 528 28 28',
        type: ContactType.services,
      ),
      Contact(
        name: 'bpost',
        phoneNumber: '+32 22 01 23 45',
        type: ContactType.services,
      ),
      Contact(
        name: 'Proximus',
        phoneNumber: '+32 800 33 800',
        type: ContactType.services,
      ),
      Contact(
        name: 'Electrabel',
        phoneNumber: '+32 78 35 34 34',
        type: ContactType.services,
      ),

      // Business (2 contacts)
      Contact(
        name: 'Restaurant Chez Marie',
        phoneNumber: '+32 9 233 45 67',
        type: ContactType.business,
      ),
      Contact(
        name: 'Garage Peeters',
        phoneNumber: '+32 3 456 78 90',
        type: ContactType.business,
      ),

      // Government (2 contacts)
      Contact(
        name: 'Stad Gent',
        phoneNumber: '+32 9 266 54 32',
        type: ContactType.government,
      ),
      Contact(
        name: 'Belastingen',
        phoneNumber: '+32 2 572 57 57',
        type: ContactType.government,
      ),
    ];
  }
}
