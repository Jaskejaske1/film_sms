import '../models/contact.dart';
import '../models/message.dart';
import '../models/conversation.dart';

class BelgianConversationsData {
  static List<Conversation> getAllConversations(List<Contact> contacts) {
    final conversations = <Conversation>[];

    // Helper to find contact by name
    Contact findContact(String name) {
      return contacts.firstWhere((c) => c.name.contains(name));
    }

    // Helper to create message
    Message createMessage(
      String body,
      bool isIncoming,
      DateTime time,
      String contactId,
    ) {
      return Message(
        body: body,
        isIncoming: isIncoming,
        timestamp: time,
        contactId: contactId,
      );
    }

    final now = DateTime.now();

    // 1. Mama - Family conversation (ensure unique last timestamp)
    final mama = findContact('Mama');
    conversations.add(
      Conversation(
        contactId: mama.id,
        messages: [
          createMessage(
            'Heb je goed gegeten vandaag?',
            true,
            now.subtract(const Duration(hours: 3)),
            mama.id,
          ),
          createMessage(
            'Ja mama, alles goed! 😊',
            false,
            now.subtract(const Duration(hours: 2, minutes: 45)),
            mama.id,
          ),
          createMessage(
            'Mooi zo. Vergeet niet je was mee te nemen als je komt eten zondag.',
            true,
            now.subtract(const Duration(hours: 2, minutes: 30)),
            mama.id,
          ),
          createMessage(
            'Oké, ik zal eraan denken!',
            false,
            now.subtract(const Duration(hours: 2, minutes: 16)),
            mama.id,
          ),
        ],
      ),
    );

    // 2. Papa - Weekend plans
    final papa = findContact('Papa');
    conversations.add(
      Conversation(
        contactId: papa.id,
        messages: [
          createMessage(
            'Kunnen we zaterdag samen naar de match van Club Brugge gaan?',
            true,
            now.subtract(const Duration(days: 1, hours: 5)),
            papa.id,
          ),
          createMessage(
            'Goede idee! Hoe laat beginnen ze?',
            false,
            now.subtract(const Duration(days: 1, hours: 4, minutes: 30)),
            papa.id,
          ),
          createMessage(
            'Om 20u30. Ik koop de tickets online.',
            true,
            now.subtract(const Duration(days: 1, hours: 4)),
            papa.id,
          ),
          createMessage(
            'Perfect! Tot zaterdag dan.',
            false,
            now.subtract(const Duration(days: 1, hours: 3, minutes: 45)),
            papa.id,
          ),
        ],
      ),
    );

    // 3. Zus Emma - Casual chat
    final emma = findContact('Emma');
    conversations.add(
      Conversation(
        contactId: emma.id,
        messages: [
          createMessage(
            'Heb jij dat nieuwe restaurant in de Voldersstraat al geprobeerd?',
            true,
            now.subtract(const Duration(hours: 6)),
            emma.id,
          ),
          createMessage(
            'Nee nog niet, is het goed?',
            false,
            now.subtract(const Duration(hours: 5, minutes: 45)),
            emma.id,
          ),
          createMessage(
            'Heel lekker! We zouden er volgende week naartoe kunnen gaan?',
            true,
            now.subtract(const Duration(hours: 5, minutes: 30)),
            emma.id,
          ),
          createMessage(
            'Ja leuk! Stuur me de details door.',
            false,
            now.subtract(const Duration(hours: 5, minutes: 15)),
            emma.id,
          ),
        ],
      ),
    );

    // 4. NMBS - Service updates
    final nmbs = findContact('NMBS');
    conversations.add(
      Conversation(
        contactId: nmbs.id,
        messages: [
          createMessage(
            'Vertraging van 10 minuten voor trein IC 1832 Antwerpen - Brussel door seinproblemen ter hoogte van Mechelen.',
            true,
            now.subtract(const Duration(hours: 4)),
            nmbs.id,
          ),
          createMessage(
            'Trein IC 1832 vertrekt nu vanaf perron 2 in plaats van perron 1. Onze excuses voor het ongemak.',
            true,
            now.subtract(const Duration(hours: 3, minutes: 45)),
            nmbs.id,
          ),
        ],
      ),
    );

    // 5. Baas - Work conversation
    final baas = findContact('Dirk');
    conversations.add(
      Conversation(
        contactId: baas.id,
        messages: [
          createMessage(
            'De vergadering van morgen wordt verplaatst naar 14u00. Kan jij je agenda aanpassen?',
            true,
            now.subtract(const Duration(hours: 8)),
            baas.id,
          ),
          createMessage(
            'Ja, dat komt goed uit. Waar vindt de vergadering plaats?',
            false,
            now.subtract(const Duration(hours: 7, minutes: 45)),
            baas.id,
          ),
          createMessage(
            'In vergaderzaal B op de tweede verdieping. Tot morgen!',
            true,
            now.subtract(const Duration(hours: 7, minutes: 30)),
            baas.id,
          ),
        ],
      ),
    );

    // 6. Lisa - Friend conversation
    final lisa = findContact('Lisa');
    conversations.add(
      Conversation(
        contactId: lisa.id,
        messages: [
          createMessage(
            'Gaan we dit weekend naar de Gentse Feesten?',
            true,
            now.subtract(const Duration(days: 2, hours: 3)),
            lisa.id,
          ),
          createMessage(
            'Ja zeker! Welke dag past het beste?',
            false,
            now.subtract(const Duration(days: 2, hours: 2, minutes: 45)),
            lisa.id,
          ),
          createMessage(
            'Zaterdag? Dan kunnen we de avondconcerten meepakken.',
            true,
            now.subtract(const Duration(days: 2, hours: 2, minutes: 30)),
            lisa.id,
          ),
          createMessage(
            'Perfect! Om hoe laat spreken we af?',
            false,
            now.subtract(const Duration(days: 2, hours: 2, minutes: 15)),
            lisa.id,
          ),
          createMessage(
            '19u00 aan de Korenmarkt?',
            true,
            now.subtract(const Duration(days: 2, hours: 2)),
            lisa.id,
          ),
        ],
      ),
    );

    // 7. bpost - Delivery notification (ensure unique last timestamp)
    final bpost = findContact('bpost');
    conversations.add(
      Conversation(
        contactId: bpost.id,
        messages: [
          createMessage(
            'Uw pakje met tracking nummer BE1234567890 wordt vandaag tussen 14u00 en 18u00 geleverd. Zorg dat er iemand thuis is.',
            true,
            now.subtract(const Duration(hours: 6, minutes: 30)),
            bpost.id,
          ),
          createMessage(
            'Pakje succesvol afgeleverd om 16u23. Bedankt voor uw vertrouwen in bpost!',
            true,
            now.subtract(const Duration(hours: 2, minutes: 14)),
            bpost.id,
          ),
        ],
      ),
    );

    // 8. Reserved for additional conversation slot (kept for numbering)

    // 9. Broer Tom (family)
    final tom = findContact('Tom');
    conversations.add(
      Conversation(
        contactId: tom.id,
        messages: [
          createMessage(
            'Krijg ik je oude monitor nog?',
            true,
            now.subtract(const Duration(days: 3, hours: 2)),
            tom.id,
          ),
          createMessage(
            'Ja, ik breng hem zondag mee.',
            false,
            now.subtract(const Duration(days: 3, hours: 1, minutes: 42)),
            tom.id,
          ),
        ],
      ),
    );

    // 10. Oma Mie (family)
    final oma = findContact('Oma');
    conversations.add(
      Conversation(
        contactId: oma.id,
        messages: [
          createMessage(
            'Wanneer kom je nog eens op bezoek?',
            true,
            now.subtract(const Duration(days: 5, hours: 6)),
            oma.id,
          ),
          createMessage(
            'Volgende week vrijdag namiddag, oké?',
            false,
            now.subtract(const Duration(days: 5, hours: 5, minutes: 40)),
            oma.id,
          ),
        ],
      ),
    );

    // 11. Opa Jan (family)
    final opa = findContact('Opa');
    conversations.add(
      Conversation(
        contactId: opa.id,
        messages: [
          createMessage(
            'Ik heb je brief gekregen, bedankt!',
            true,
            now.subtract(const Duration(days: 7, hours: 3)),
            opa.id,
          ),
          createMessage(
            'Graag gedaan! Tot binnenkort.',
            false,
            now.subtract(const Duration(days: 7, hours: 2, minutes: 35)),
            opa.id,
          ),
        ],
      ),
    );

    // 12. Tante Lies (family)
    final tante = findContact('Lies');
    conversations.add(
      Conversation(
        contactId: tante.id,
        messages: [
          createMessage(
            'Kom je mee helpen op het tuinfeest?',
            true,
            now.subtract(const Duration(days: 10, hours: 1)),
            tante.id,
          ),
          createMessage(
            'Ja, ik breng salade mee.',
            false,
            now.subtract(const Duration(days: 10, hours: 0, minutes: 45)),
            tante.id,
          ),
        ],
      ),
    );

    // 13. Oom Karel (family)
    final oom = findContact('Karel');
    conversations.add(
      Conversation(
        contactId: oom.id,
        messages: [
          createMessage(
            'Heb je nog een ladder die ik mag lenen?',
            true,
            now.subtract(const Duration(days: 9, hours: 4)),
            oom.id,
          ),
          createMessage(
            'Zeker, ik leg hem klaar in de garage.',
            false,
            now.subtract(const Duration(days: 9, hours: 3, minutes: 50)),
            oom.id,
          ),
        ],
      ),
    );

    // 14. Sarah (HR) (work)
    final sarah = findContact('Sarah');
    conversations.add(
      Conversation(
        contactId: sarah.id,
        messages: [
          createMessage(
            'Bevestiging: je verlof staat ingepland van 12/09 tot 16/09.',
            true,
            now.subtract(const Duration(days: 12, hours: 2)),
            sarah.id,
          ),
        ],
      ),
    );

    // 15. Luc (Collega) (work)
    final luc = findContact('Luc');
    conversations.add(
      Conversation(
        contactId: luc.id,
        messages: [
          createMessage(
            'Kan jij de presentatie afwerken tegen 15u?',
            true,
            now.subtract(const Duration(days: 1, hours: 6)),
            luc.id,
          ),
          createMessage(
            'Ja, ik stuur ze straks door.',
            false,
            now.subtract(const Duration(days: 1, hours: 5, minutes: 30)),
            luc.id,
          ),
        ],
      ),
    );

    // 16. Martine (Project) (work)
    final martine = findContact('Martine');
    conversations.add(
      Conversation(
        contactId: martine.id,
        messages: [
          createMessage(
            'Planningupdate: sprint demo donderdag om 11u.',
            true,
            now.subtract(const Duration(days: 2, hours: 1)),
            martine.id,
          ),
        ],
      ),
    );

    // 17. IT Support (work)
    final it = findContact('IT Support');
    conversations.add(
      Conversation(
        contactId: it.id,
        messages: [
          createMessage(
            'Jouw ticket #48321 is opgelost. Graag bevestigen.',
            true,
            now.subtract(const Duration(hours: 20)),
            it.id,
          ),
          createMessage(
            'Bevestigd, bedankt!',
            false,
            now.subtract(const Duration(hours: 19, minutes: 20)),
            it.id,
          ),
        ],
      ),
    );

    // 18. Matthias (friends)
    final matthias = findContact('Matthias');
    conversations.add(
      Conversation(
        contactId: matthias.id,
        messages: [
          createMessage(
            'Pintje vanavond in de Overpoort?',
            true,
            now.subtract(const Duration(days: 2, hours: 6)),
            matthias.id,
          ),
          createMessage(
            'Ik kan pas om 22u.',
            false,
            now.subtract(const Duration(days: 2, hours: 5, minutes: 45)),
            matthias.id,
          ),
        ],
      ),
    );

    // 19. Sofie (friends)
    final sofie = findContact('Sofie');
    conversations.add(
      Conversation(
        contactId: sofie.id,
        messages: [
          createMessage(
            'Zondag yoga in het Citadelpark?',
            true,
            now.subtract(const Duration(days: 4, hours: 2)),
            sofie.id,
          ),
          createMessage(
            'Ja! Om 10u dan?',
            false,
            now.subtract(const Duration(days: 4, hours: 1, minutes: 50)),
            sofie.id,
          ),
        ],
      ),
    );

    // 20. Kevin (friends)
    final kevin = findContact('Kevin');
    conversations.add(
      Conversation(
        contactId: kevin.id,
        messages: [
          createMessage(
            'Heb je die PS5 game al gekocht?',
            true,
            now.subtract(const Duration(days: 3, hours: 8)),
            kevin.id,
          ),
          createMessage(
            'Nee, wacht op promotie bij Krefel.',
            false,
            now.subtract(const Duration(days: 3, hours: 7, minutes: 55)),
            kevin.id,
          ),
        ],
      ),
    );

    // 21. Proximus (services)
    final proximus = findContact('Proximus');
    conversations.add(
      Conversation(
        contactId: proximus.id,
        messages: [
          createMessage(
            'Factuur klaar: €52,30 — vervaldag 28/09.',
            true,
            now.subtract(const Duration(days: 1, hours: 2)),
            proximus.id,
          ),
        ],
      ),
    );

    // 22. Electrabel (services)
    final electrabel = findContact('Electrabel');
    conversations.add(
      Conversation(
        contactId: electrabel.id,
        messages: [
          createMessage(
            'Meteropname gepland op 03/10 tussen 9u en 12u.',
            true,
            now.subtract(const Duration(days: 6, hours: 3)),
            electrabel.id,
          ),
        ],
      ),
    );

    // 23. Restaurant Chez Marie (business)
    final chez = findContact('Restaurant Chez Marie');
    conversations.add(
      Conversation(
        contactId: chez.id,
        messages: [
          createMessage(
            'Reservatie bevestigd voor 2 personen op vrijdag 20u.',
            true,
            now.subtract(const Duration(days: 2, hours: 3)),
            chez.id,
          ),
        ],
      ),
    );

    // 24. Garage Peeters (business)
    final garage = findContact('Garage Peeters');
    conversations.add(
      Conversation(
        contactId: garage.id,
        messages: [
          createMessage(
            'Herstelling klaar. Factuur €236,40. Ophalen kan tot 18u.',
            true,
            now.subtract(const Duration(days: 1, hours: 5)),
            garage.id,
          ),
        ],
      ),
    );

    // 25. Stad Gent (government)
    final stad = findContact('Stad Gent');
    conversations.add(
      Conversation(
        contactId: stad.id,
        messages: [
          createMessage(
            'Afspraak loket: donderdag 11u30 — loket 4, Woodrow Wilsonplein.',
            true,
            now.subtract(const Duration(days: 3, hours: 1)),
            stad.id,
          ),
        ],
      ),
    );

    // 26. Belastingen (government)
    final belastingen = findContact('Belastingen');
    conversations.add(
      Conversation(
        contactId: belastingen.id,
        messages: [
          createMessage(
            'Herinnering: onroerende voorheffing vervalt op 05/10. Betaal tijdig om verhogingen te vermijden.',
            true,
            now.subtract(const Duration(days: 2, hours: 4)),
            belastingen.id,
          ),
        ],
      ),
    );

    // Adjust lastMessageTime and unreadCount accordingly
    for (var i = 0; i < conversations.length; i++) {
      final conv = conversations[i];
      final last = conv.messages.isNotEmpty ? conv.messages.last : null;
      conversations[i] = Conversation(
        id: conv.id,
        contactId: conv.contactId,
        messages: conv.messages,
        lastMessageTime: last?.timestamp ?? now.subtract(Duration(minutes: i)),
        unreadCount: (last?.isIncoming ?? false) ? 1 : 0,
        isPinned: false,
      );
    }

    return conversations;
  }
}
