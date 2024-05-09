1 pragma solidity ^0.4.2;
2 
3 /* Родительский контракт */
4 contract Owned {
5 
6     /* Адрес владельца контракта*/
7     address owner;
8 
9     /* Конструктор контракта, вызывается при первом запуске */
10     function Owned() {
11         owner = msg.sender;
12     }
13 
14     /* Изменить владельца контракта, newOwner - адрес нового владельца */
15     function changeOwner(address newOwner) onlyowner {
16         owner = newOwner;
17     }
18 
19     /* Модификатор для ограничения доступа к функциям только для владельца */
20     modifier onlyowner() {
21         if (msg.sender==owner) _;
22     }
23 
24     /* Удалить контракт */
25     function kill() onlyowner {
26         if (msg.sender == owner) suicide(owner);
27     }
28 }
29 
30 /* Основной контракт, наследует контракт Owned */
31 contract Gods is Owned {
32 
33     /* Структура представляющая участника */
34     struct Member {
35         address member;
36         string name;
37         string surname;
38         string patronymic;
39         uint birthDate;
40         string birthPlace;
41         string avatarHash;
42         uint avatarID;
43         bool approved;
44         uint memberSince;
45     }
46 
47     /* Массив участников */
48     Member[] public members;
49 
50     /* Маппинг адрес участника -> id участника */
51     mapping (address => uint) public memberId;
52 
53     /* Маппинг id участника -> приватный ключ кошелька */
54     mapping (uint => string) public pks;
55 
56     /* Маппинг id участника -> дополнительные данные на участника в формате JSON */
57     mapping (uint => string) public memberData;
58 
59     /* Событие при добавлении участника, параметры - адрес, ID */
60     event MemberAdded(address member, uint id);
61 
62     /* Событие при изменении участника, параметры - адрес, ID */
63     event MemberChanged(address member, uint id);
64 
65     /* Конструктор контракта, вызывается при первом запуске */
66     function Gods() {
67         /* Добавляем пустого участника для инициализации */
68         addMember('', '', '', 0, '', '', 0, '');
69     }
70 
71     /* функция добавления и обновления участника, параметры - адрес, имя, фамилия,
72      отчество, дата рождения (linux time), место рождения, хэш аватара, ID аватара
73      если пользователь с таким адресом не найден, то будет создан новый, в конце вызовется событие
74      MemberAdded, если пользователь найден, то будет произведено обновление полей и проставлен флаг
75      подтверждения approved */
76     function addMember(string name,
77         string surname,
78         string patronymic,
79         uint birthDate,
80         string birthPlace,
81         string avatarHash,
82         uint avatarID,
83         string data) onlyowner {
84         uint id;
85         address member = msg.sender;
86         if (memberId[member] == 0) {
87             memberId[member] = members.length;
88             id = members.length++;
89             members[id] = Member({
90                 member: member,
91                 name: name,
92                 surname: surname,
93                 patronymic: patronymic,
94                 birthDate: birthDate,
95                 birthPlace: birthPlace,
96                 avatarHash: avatarHash,
97                 avatarID: avatarID,
98                 approved: (owner == member),
99                 memberSince: now
100             });
101             memberData[id] = data;
102             if (member != 0) {
103                 MemberAdded(member, id);
104             }
105         } else {
106             id = memberId[member];
107             Member m = members[id];
108             m.approved = true;
109             m.name = name;
110             m.surname = surname;
111             m.patronymic = patronymic;
112             m.birthDate = birthDate;
113             m.birthPlace = birthPlace;
114             m.avatarHash = avatarHash;
115             m.avatarID = avatarID;
116             memberData[id] = data;
117             MemberChanged(member, id);
118         }
119     }
120 
121     /* Функция получения приватного ключа по ID юзера */
122     function getPK(uint id) onlyowner constant returns (string) {
123         return pks[id];
124     }
125 
126     /* Функция получения количества юзеров */
127     function getMemberCount() constant returns (uint) {
128         return members.length - 1;
129     }
130 
131     /* Функция получения юзера по id
132      возвращает массив из полей [имя, фамилия, отчество, дата_рождения, хэш аватара, id аватара] */
133     function getMember(uint id) constant returns (
134         string name,
135         string surname,
136         string patronymic,
137         uint birthDate,
138         string birthPlace,
139         string avatarHash,
140         uint avatarID,
141         string data) {
142         Member m = members[id];
143         name = m.name;
144         surname = m.surname;
145         patronymic = m.patronymic;
146         birthDate = m.birthDate;
147         birthPlace = m.birthPlace;
148         avatarHash = m.avatarHash;
149         avatarID = m.avatarID;
150         data = memberData[id];
151     }
152 }