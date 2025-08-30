//
//  HistoryData.swift
//  DaFoEgypt1
//
//  Created by IGOR on 29/08/2025.
//

import Foundation

// MARK: - History Articles Data
struct HistoryDataProvider {
    static let articles: [HistoryArticle] = [
        // Pharaohs
        HistoryArticle(
            title: "Tutankhamun: The Boy King",
            summary: "Discover the fascinating story of Egypt's most famous pharaoh who ruled at just 9 years old.",
            content: """
            Tutankhamun, often called King Tut, became pharaoh of Egypt when he was only about 9 years old, around 1332 BCE. Despite his young age, he ruled during a crucial period in Egyptian history.

            **Early Life and Rise to Power**
            Born as Tutankhaten, he was likely the son of the controversial pharaoh Akhenaten. When he became king, Egypt was in religious and political turmoil due to his father's radical changes to Egyptian religion.

            **Religious Restoration**
            One of Tutankhamun's most important acts was restoring the traditional Egyptian gods. His father had tried to make Aten the only god, but Tutankhamun brought back Amun-Ra and other beloved deities. He even changed his name from Tutankhaten to Tutankhamun to honor the god Amun.

            **The Golden Pharaoh**
            Tutankhamun's tomb, discovered by Howard Carter in 1922, contained over 5,000 precious objects, including his famous golden death mask. This treasure trove gave us incredible insights into ancient Egyptian burial practices and royal life.

            **Mystery of His Death**
            The young pharaoh died around age 19, and his death remains a mystery. Some theories suggest he died in a chariot accident, while others propose he was murdered. Recent studies of his mummy show he had a broken leg and skull damage.

            **Legacy**
            Though he ruled for only about 10 years, Tutankhamun became the most famous pharaoh in modern times. His tomb's discovery sparked worldwide fascination with ancient Egypt and continues to inspire people today.
            """,
            imageIcon: "👑",
            category: .pharaohs,
            readingTime: 4
        ),
        
        HistoryArticle(
            title: "Cleopatra VII: The Last Pharaoh",
            summary: "Learn about the intelligent and powerful queen who spoke nine languages and ruled Egypt for nearly two decades.",
            content: """
            Cleopatra VII, the last active pharaoh of ancient Egypt, was far more than the beautiful seductress often portrayed in movies. She was a brilliant ruler, diplomat, and scholar who fought to preserve Egypt's independence.

            **A Brilliant Mind**
            Cleopatra was highly educated and spoke at least nine languages, including Egyptian, Greek, Latin, and Hebrew. She was the first Ptolemaic ruler in 300 years to learn the Egyptian language, showing her connection to her people.

            **Political Genius**
            She formed strategic alliances with Julius Caesar and later Mark Antony, not just for romance, but to protect Egypt from Roman conquest. These relationships were calculated political moves to maintain Egypt's power and independence.

            **Economic Prosperity**
            Under her rule, Egypt remained wealthy and prosperous. She controlled important trade routes and Egypt's grain production, making her kingdom essential to the Roman Empire's survival.

            **Cultural Patron**
            Cleopatra supported arts, sciences, and learning. The famous Library of Alexandria flourished under her patronage, and she personally funded many scholarly works and architectural projects.

            **The Final Battle**
            Her alliance with Mark Antony led to war with Octavian (later Augustus Caesar). After their defeat at the Battle of Actium in 31 BCE, both Cleopatra and Antony committed suicide rather than be captured.

            **Lasting Legacy**
            Cleopatra's death marked the end of the Ptolemaic dynasty and Egypt's independence. However, her intelligence, political skill, and dedication to Egypt have made her one of history's most fascinating figures.
            """,
            imageIcon: "👸",
            category: .pharaohs,
            readingTime: 5
        ),
        
        HistoryArticle(
            title: "Ramesses II: The Great Builder",
            summary: "Explore the reign of Ramesses the Great, who built more monuments than any other pharaoh.",
            content: """
            Ramesses II, known as Ramesses the Great, ruled Egypt for 66 years (1279-1213 BCE) and is considered one of the most powerful pharaohs in Egyptian history.

            **The Great Builder**
            Ramesses II built more temples, monuments, and statues than any other pharaoh. His most famous constructions include Abu Simbel, the additions to Karnak Temple, and his mortuary temple, the Ramesseum.

            **Military Campaigns**
            He led numerous military campaigns, most famously the Battle of Kadesh against the Hittites around 1274 BCE. Though the battle was inconclusive, Ramesses portrayed it as a great victory in his monuments.

            **The First Peace Treaty**
            After years of conflict, Ramesses II signed the world's first known peace treaty with the Hittite king Hattusili III. A copy of this treaty is displayed at the United Nations headquarters.

            **Family Life**
            Ramesses had over 100 children with his many wives. His favorite wife was Nefertari, for whom he built a beautiful tomb in the Valley of the Queens and a temple at Abu Simbel.

            **Architectural Marvels**
            The temples at Abu Simbel, carved directly into rock cliffs, feature four colossal statues of Ramesses II. These temples were relocated in the 1960s to save them from flooding when the Aswan High Dam was built.

            **Death and Legacy**
            Ramesses II lived to about 90 years old, an extraordinary age for ancient times. His mummy shows he was tall for his era and had red hair. His long reign brought stability and prosperity to Egypt.
            """,
            imageIcon: "🏛️",
            category: .pharaohs,
            readingTime: 4
        ),
        
        // Pyramids
        HistoryArticle(
            title: "The Great Pyramid of Giza",
            summary: "Uncover the secrets of the last remaining Wonder of the Ancient World.",
            content: """
            The Great Pyramid of Giza, built for Pharaoh Khufu around 2580-2560 BCE, is the oldest and largest of the three pyramids in the Giza pyramid complex and the only surviving Wonder of the Ancient World.

            **Incredible Statistics**
            Originally standing at 146.5 meters (481 feet) tall, the Great Pyramid was the world's tallest human-made structure for over 3,800 years. It contains approximately 2.3 million stone blocks, each weighing between 2.5 and 15 tons.

            **Construction Mystery**
            How the ancient Egyptians built this massive structure remains one of history's greatest mysteries. Theories include ramps, levers, and sophisticated engineering techniques that we're still trying to understand today.

            **Perfect Alignment**
            The pyramid is aligned almost perfectly with the cardinal directions, with an accuracy of 3/60th of a degree. This precision suggests advanced astronomical knowledge and surveying techniques.

            **Hidden Chambers**
            The pyramid contains three known chambers: the King's Chamber, the Queen's Chamber, and an unfinished chamber carved into the bedrock. Recent discoveries using cosmic ray imaging have revealed additional hidden chambers.

            **The Great Gallery**
            One of the pyramid's most impressive features is the Great Gallery, a corbelled ceiling passage that leads to the King's Chamber. Its purpose and construction method continue to puzzle archaeologists.

            **Modern Discoveries**
            In 2017, scientists using muon tomography discovered a large void above the Great Gallery. This chamber, about 30 meters long, has sparked new theories about the pyramid's construction and purpose.

            **Enduring Wonder**
            After 4,500 years, the Great Pyramid continues to reveal its secrets. It remains a testament to ancient Egyptian engineering prowess and continues to inspire wonder in millions of visitors each year.
            """,
            imageIcon: "🔺",
            category: .pyramids,
            readingTime: 5
        ),
        
        HistoryArticle(
            title: "The Pyramid Builders",
            summary: "Meet the skilled workers who built Egypt's eternal monuments.",
            content: """
            Contrary to popular belief, the pyramids were not built by slaves but by skilled workers who were well-fed, housed, and respected for their craftsmanship.

            **The Worker Villages**
            Archaeological evidence shows that pyramid builders lived in purpose-built villages near the construction sites. These settlements included bakeries, breweries, and medical facilities, indicating the workers were well cared for.

            **Skilled Craftsmen**
            The workforce included skilled stonemasons, architects, engineers, and artists. Many workers had specialized roles, from quarrying stones to precisely placing blocks and creating intricate decorations.

            **Organization and Logistics**
            Building a pyramid required incredible organization. Teams were divided into crews with names like "Friends of Khufu" and "Drunkards of Menkaure," showing a sense of pride and competition among workers.

            **Diet and Health**
            Analysis of worker remains shows they ate well, with diets including bread, beer, onions, garlic, and meat. However, the physical demands of construction left many with injuries and worn joints.

            **Seasonal Work**
            Much of the heavy construction likely took place during the Nile's flood season when farmers couldn't work their fields. This provided a large labor force during the optimal construction period.

            **Tools and Techniques**
            Workers used copper tools, wooden levers, ropes, and ramps to move massive stone blocks. They developed sophisticated techniques for cutting, transporting, and precisely placing stones.

            **Legacy of the Builders**
            These anonymous workers created monuments that have lasted over 4,000 years. Their skills and dedication gave us some of humanity's most impressive architectural achievements.
            """,
            imageIcon: "👷",
            category: .pyramids,
            readingTime: 4
        ),
        
        // Gods & Goddesses
        HistoryArticle(
            title: "Ra: The Sun God",
            summary: "Discover the most important deity in the Egyptian pantheon who sailed across the sky each day.",
            content: """
            Ra, the ancient Egyptian sun god, was one of the most important deities in the Egyptian pantheon and was considered the king of the gods during much of ancient Egyptian history.

            **The Solar Journey**
            According to Egyptian mythology, Ra sailed across the sky each day in his solar barque, bringing light and life to the world. At night, he traveled through the underworld, battling the serpent Apophis to ensure the sun would rise again.

            **Forms and Representations**
            Ra was often depicted as a man with the head of a falcon, crowned with a sun disk and uraeus (cobra). He could also appear as a scarab beetle (Khepri) in the morning or as an old man (Atum) in the evening.

            **The Eye of Ra**
            The Eye of Ra was a powerful symbol representing the sun god's protective and destructive power. It was often depicted as a cobra or lioness and was believed to protect the pharaoh and Egypt from enemies.

            **Fusion with Other Gods**
            Ra was often combined with other deities, most notably Amun to create Amun-Ra, the supreme god of the New Kingdom. This fusion showed Ra's importance and adaptability in Egyptian religion.

            **The Pharaoh Connection**
            Egyptian pharaohs were considered the earthly embodiment of Ra. The title "Son of Ra" was part of the royal titulary, emphasizing the divine nature of kingship and the pharaoh's role as Ra's representative on earth.

            **Temples and Worship**
            Ra's most important temple was at Heliopolis, where priests maintained eternal flames and performed daily rituals to ensure the sun's continued journey. Obelisks were erected as symbols of Ra's power.

            **Decline and Legacy**
            While Ra's prominence declined in later periods, his influence remained strong. The concept of a supreme sun deity influenced later religions and continues to fascinate people today.
            """,
            imageIcon: "☀️",
            category: .gods,
            readingTime: 4
        ),
        
        HistoryArticle(
            title: "Isis: The Divine Mother",
            summary: "Learn about the goddess of magic, motherhood, and healing who became one of the most beloved deities.",
            content: """
            Isis was one of ancient Egypt's most important and beloved goddesses, revered as the ideal mother, wife, and patron of nature and magic.

            **The Osiris Myth**
            Isis is central to one of Egypt's most important myths. When her husband Osiris was murdered and dismembered by his brother Set, Isis used her magical powers to reassemble his body and resurrect him, conceiving their son Horus in the process.

            **Goddess of Magic**
            Isis was considered the most powerful magician among the gods. She knew the secret name of Ra and could perform incredible feats of magic. Egyptians believed she could heal the sick and protect the living and the dead.

            **Divine Motherhood**
            As the mother of Horus, Isis became the archetypal divine mother. She was often depicted nursing the infant Horus, an image that influenced later religious iconography in other cultures.

            **Protector of the Dead**
            Along with her sister Nephthys, Isis protected the deceased. She was often shown with outstretched wings, sheltering the dead and helping them in their journey to the afterlife.

            **Symbols and Representations**
            Isis was typically depicted as a woman wearing a throne-shaped crown or cow horns with a sun disk. Her symbols included the ankh (life), the tyet (Isis knot), and the sistrum (musical instrument).

            **Widespread Worship**
            Isis's cult spread far beyond Egypt, reaching Greece, Rome, and other parts of the ancient world. She became one of the most widely worshipped deities in the ancient Mediterranean.

            **Temples and Festivals**
            The temple of Isis at Philae was one of her most important cult centers. Annual festivals celebrated her role in Osiris's resurrection and the flooding of the Nile, which brought life to Egypt.

            **Lasting Influence**
            Isis worship continued well into the Roman period and influenced early Christianity. Her image as a divine mother and her promise of salvation resonated with people across cultures and centuries.
            """,
            imageIcon: "👩‍👧‍👦",
            category: .gods,
            readingTime: 5
        ),
        
        // Daily Life
        HistoryArticle(
            title: "Life Along the Nile",
            summary: "Experience daily life in ancient Egypt, from farmers to pharaohs.",
            content: """
            The Nile River was the lifeblood of ancient Egypt, and daily life revolved around its annual flood cycle and the fertile land it created.

            **The Farmer's Year**
            Most Egyptians were farmers whose lives followed the Nile's three seasons: Akhet (flood season), Peret (growing season), and Shemu (harvest season). During floods, many farmers worked on royal construction projects.

            **Family Life**
            Egyptian families were typically nuclear, with parents and children living together. Children were highly valued, and both boys and girls received education, though boys had more opportunities for formal schooling.

            **Food and Drink**
            The Egyptian diet centered on bread and beer, supplemented with vegetables like onions, leeks, and garlic. Meat was a luxury for most people, though fish from the Nile was common. Honey was the primary sweetener.

            **Clothing and Fashion**
            Egyptians wore linen clothing suited to the hot climate. Men typically wore kilts, while women wore straight dresses. Jewelry was popular among all social classes, from simple copper pieces to elaborate gold ornaments.

            **Work and Crafts**
            Egyptian society included many specialized craftsmen: potters, weavers, metalworkers, and scribes. Scribes held particularly high status as literacy was rare and valuable.

            **Housing**
            Most Egyptians lived in simple mud-brick houses with flat roofs. Wealthy families had larger homes with courtyards and gardens. Houses were often painted white to reflect heat.

            **Religion in Daily Life**
            Religion permeated daily life. Egyptians wore amulets for protection, made offerings to household gods, and participated in religious festivals throughout the year.

            **Entertainment**
            Egyptians enjoyed music, dancing, board games like Senet, and storytelling. Children played with toys including dolls, balls, and miniature animals.
            """,
            imageIcon: "🏘️",
            category: .dailyLife,
            readingTime: 4
        ),
        
        // Mysteries
        HistoryArticle(
            title: "The Sphinx's Secret",
            summary: "Explore the mysteries surrounding the Great Sphinx of Giza and its hidden chambers.",
            content: """
            The Great Sphinx of Giza, with its human head and lion's body, has guarded the Giza plateau for over 4,500 years, but many of its secrets remain unsolved.

            **Ancient Origins**
            Most scholars believe the Sphinx was carved during the reign of Pharaoh Khafre (c. 2558-2532 BCE), but some theories suggest it could be much older. The weathering patterns on the Sphinx have sparked debates about its true age.

            **The Missing Nose**
            Contrary to popular belief, Napoleon's troops did not shoot off the Sphinx's nose. Historical drawings show the nose was already missing in the 1700s. It was likely damaged by erosion or deliberate vandalism centuries earlier.

            **Hidden Chambers**
            Ground-penetrating radar and seismic studies have detected possible chambers beneath and within the Sphinx. These mysterious spaces have fueled speculation about hidden treasures or secret knowledge.

            **The Hall of Records**
            Edgar Cayce, a famous psychic, claimed there was a "Hall of Records" beneath the Sphinx containing ancient wisdom. While no such chamber has been found, the idea continues to capture imaginations.

            **Restoration Efforts**
            The Sphinx has undergone numerous restoration attempts throughout history. Ancient pharaohs, including Thutmose IV, cleared sand from around it and made repairs, showing it was already ancient and mysterious to them.

            **Astronomical Alignments**
            Some researchers believe the Sphinx is aligned with certain stars or constellations, possibly serving as an astronomical marker or calendar. The lion's body might represent the constellation Leo.

            **The Riddle Connection**
            The famous riddle "What walks on four legs in the morning, two legs at noon, and three legs in the evening?" is associated with the Greek Sphinx, not the Egyptian one, but both share the theme of ancient wisdom and mystery.

            **Modern Investigations**
            Recent technological advances, including 3D scanning and chemical analysis, continue to reveal new information about the Sphinx's construction and history, but many questions remain unanswered.
            """,
            imageIcon: "🦁",
            category: .mysteries,
            readingTime: 5
        )
    ]
    
    static let pharaohs: [PharaoTimeline] = [
        PharaoTimeline(
            name: "Narmer (Menes)",
            dynasty: "1st Dynasty",
            reignStart: 3100,
            reignEnd: 3050,
            achievements: ["United Upper and Lower Egypt", "Founded Memphis", "Established the first dynasty"],
            funFact: "His name means 'Fierce Catfish' and he's considered the first pharaoh of unified Egypt!"
        ),
        PharaoTimeline(
            name: "Djoser",
            dynasty: "3rd Dynasty",
            reignStart: 2670,
            reignEnd: 2650,
            achievements: ["Built the first pyramid (Step Pyramid)", "Established royal burial traditions", "Promoted architectural innovation"],
            funFact: "His architect Imhotep was so brilliant that he was later worshipped as a god!"
        ),
        PharaoTimeline(
            name: "Khufu",
            dynasty: "4th Dynasty",
            reignStart: 2589,
            reignEnd: 2566,
            achievements: ["Built the Great Pyramid of Giza", "Organized massive construction projects", "Established pyramid building techniques"],
            funFact: "His pyramid contains about 2.3 million stone blocks - that's like building 30 Empire State Buildings!"
        ),
        PharaoTimeline(
            name: "Hatshepsut",
            dynasty: "18th Dynasty",
            reignStart: 1479,
            reignEnd: 1458,
            achievements: ["One of the most successful female pharaohs", "Built magnificent temple at Deir el-Bahari", "Established trade expeditions to Punt"],
            funFact: "She wore a fake beard and dressed as a man to assert her authority as pharaoh!"
        ),
        PharaoTimeline(
            name: "Akhenaten",
            dynasty: "18th Dynasty",
            reignStart: 1353,
            reignEnd: 1336,
            achievements: ["Introduced monotheistic worship of Aten", "Founded new capital at Amarna", "Revolutionized Egyptian art"],
            funFact: "He was probably Tutankhamun's father and tried to change Egypt's religion completely!"
        ),
        PharaoTimeline(
            name: "Tutankhamun",
            dynasty: "18th Dynasty",
            reignStart: 1332,
            reignEnd: 1323,
            achievements: ["Restored traditional Egyptian religion", "Returned capital to Thebes", "Left behind incredible tomb treasures"],
            funFact: "He became pharaoh at age 9 and his tomb is the most intact royal burial ever found!"
        ),
        PharaoTimeline(
            name: "Ramesses II",
            dynasty: "19th Dynasty",
            reignStart: 1279,
            reignEnd: 1213,
            achievements: ["Built Abu Simbel temples", "Signed first known peace treaty", "Ruled for 66 years"],
            funFact: "He had over 100 children and lived to be about 90 years old - ancient by Egyptian standards!"
        ),
        PharaoTimeline(
            name: "Cleopatra VII",
            dynasty: "Ptolemaic Dynasty",
            reignStart: 69,
            reignEnd: 30,
            achievements: ["Last active pharaoh of Egypt", "Spoke nine languages", "Formed alliances with Julius Caesar and Mark Antony"],
            funFact: "She was actually Greek, not Egyptian, and was the first Ptolemaic ruler to learn the Egyptian language!"
        )
    ]
    
    static let artifacts: [Artifact] = [
        Artifact(
            name: "Tutankhamun's Golden Mask",
            description: "The iconic funeral mask of the boy king, made of solid gold and precious stones.",
            period: "New Kingdom (1332-1323 BCE)",
            significance: "This masterpiece of ancient craftsmanship protected the pharaoh's face for eternity and shows the incredible skill of Egyptian goldsmiths.",
            imageIcon: "👑",
            discoveryYear: 1922
        ),
        Artifact(
            name: "The Rosetta Stone",
            description: "A stone slab with the same text written in three scripts: hieroglyphic, demotic, and Greek.",
            period: "Ptolemaic Period (196 BCE)",
            significance: "This stone was the key to deciphering Egyptian hieroglyphs, unlocking thousands of years of Egyptian writing and history.",
            imageIcon: "🪨",
            discoveryYear: 1799
        ),
        Artifact(
            name: "Canopic Jars",
            description: "Four jars used to store the internal organs of mummies, each protected by a different god.",
            period: "Various periods",
            significance: "These jars show Egyptian beliefs about the afterlife and the importance of preserving the body for eternal life.",
            imageIcon: "🏺",
            discoveryYear: 0 // Found in many tombs over time
        ),
        Artifact(
            name: "The Book of the Dead",
            description: "A collection of spells and instructions to help the deceased navigate the afterlife.",
            period: "New Kingdom (1550-1077 BCE)",
            significance: "These papyrus scrolls reveal Egyptian beliefs about death, judgment, and the journey to eternal life.",
            imageIcon: "📜",
            discoveryYear: 0 // Many copies found over time
        ),
        Artifact(
            name: "Nefertiti's Bust",
            description: "A limestone sculpture of Queen Nefertiti, wife of Akhenaten, showing idealized beauty.",
            period: "Amarna Period (1345 BCE)",
            significance: "This sculpture represents the artistic revolution during Akhenaten's reign and shows the beauty ideals of ancient Egypt.",
            imageIcon: "👸",
            discoveryYear: 1912
        ),
        Artifact(
            name: "The Narmer Palette",
            description: "A ceremonial palette showing the unification of Upper and Lower Egypt under Pharaoh Narmer.",
            period: "Early Dynastic Period (3100 BCE)",
            significance: "This is one of the earliest historical records of Egyptian kingship and the unification of Egypt.",
            imageIcon: "🎨",
            discoveryYear: 1898
        ),
        Artifact(
            name: "Shabti Figures",
            description: "Small mummified figurines placed in tombs to serve the deceased in the afterlife.",
            period: "Middle Kingdom onwards",
            significance: "These figures show Egyptian beliefs about work in the afterlife and the desire to maintain earthly comforts after death.",
            imageIcon: "🧸",
            discoveryYear: 0 // Found in many tombs
        ),
        Artifact(
            name: "The Sphinx Stela",
            description: "A stone tablet placed between the paws of the Great Sphinx by Thutmose IV.",
            period: "New Kingdom (1401-1391 BCE)",
            significance: "This stela tells the story of how Thutmose IV cleared sand from the Sphinx after a prophetic dream.",
            imageIcon: "📋",
            discoveryYear: 1818
        )
    ]
}

