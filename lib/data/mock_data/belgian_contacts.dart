import '../models/contact.dart';
import '../../core/constants/belgian_constants.dart';

class BelgianContactsData {
  static List<Contact> getAllContacts() {
    return [
      // Transport & Services (Dynamic)
      Contact(
        name: '',
        phoneNumber: BelgianConstants.deLijnNumber,
        type: ContactType.transport,
        isDynamic: true,
      ),

      // Family (8 contacts)
      Contact(name: 'Mama', phoneNumber: '', type: ContactType.family),
      Contact(name: 'Papa', phoneNumber: '', type: ContactType.family),
      Contact(name: 'Zus Emma', phoneNumber: '', type: ContactType.family),
      Contact(name: 'Broer Tom', phoneNumber: '', type: ContactType.family),
      Contact(name: 'Oma Mie', phoneNumber: '', type: ContactType.family),
      Contact(name: 'Opa Jan', phoneNumber: '', type: ContactType.family),
      Contact(name: 'Tante Lies', phoneNumber: '', type: ContactType.family),
      Contact(name: 'Oom Karel', phoneNumber: '', type: ContactType.family),

      // Work (5 contacts)
      Contact(
        name: 'Baas - Dirk Vermeulen',
        phoneNumber: '',
        type: ContactType.work,
      ),
      Contact(name: 'Sarah (HR)', phoneNumber: '', type: ContactType.work),
      Contact(name: 'Luc (Collega)', phoneNumber: '', type: ContactType.work),
      Contact(
        name: 'Martine (Project)',
        phoneNumber: '',
        type: ContactType.work,
      ),
      Contact(name: 'IT Support', phoneNumber: '', type: ContactType.work),

      // Friends (4 contacts)
      Contact(name: 'Lisa', phoneNumber: '', type: ContactType.friends),
      Contact(name: 'Matthias', phoneNumber: '', type: ContactType.friends),
      Contact(name: 'Sofie', phoneNumber: '', type: ContactType.friends),
      Contact(name: 'Kevin', phoneNumber: '', type: ContactType.friends),

      // Services (4 contacts)
      Contact(name: 'NMBS', phoneNumber: '', type: ContactType.services),
      Contact(name: 'bpost', phoneNumber: '', type: ContactType.services),
      Contact(name: 'Proximus', phoneNumber: '', type: ContactType.services),
      Contact(name: 'Electrabel', phoneNumber: '', type: ContactType.services),

      // Business (2 contacts)
      Contact(
        name: 'Restaurant Chez Marie',
        phoneNumber: '',
        type: ContactType.business,
      ),
      Contact(
        name: 'Garage Peeters',
        phoneNumber: '',
        type: ContactType.business,
      ),

      // Government (2 contacts)
      Contact(name: 'Stad Gent', phoneNumber: '', type: ContactType.government),
      Contact(
        name: 'Belastingen',
        phoneNumber: '',
        type: ContactType.government,
      ),
    ];
  }
}
