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
31 contract Documents is Owned {
32 
33     /* Структура представляющая документ */
34     struct Document {
35         string hash;
36         string link;
37         string data;
38         address creator;
39         uint date;
40         uint signsCount;
41         mapping (uint => Sign) signs;
42     }
43 
44     /* Структура представляющая подпись */
45     struct Sign {
46         address member;
47         uint date;
48     }
49 
50     /* Маппинг ID документа -> документ */
51     mapping (uint => Document) public documentsIds;
52 
53     /* Кол-во документов */
54     uint documentsCount = 0;
55 
56     /* Событие при подписи документа участником, параметры - адрес участника, ID документа */
57     event DocumentSigned(uint id, address member);
58 
59     /* Событие при регистрации документа, параметры - ID документа */
60     event DocumentRegistered(uint id, string hash);
61 
62      /* Конструктор контракта, вызывается при первом запуске */
63     function Documents() {
64     }
65 
66     /* функция добавления документа, параметры - хэш, ссылка, дополнительные данные, создатель.
67     Если не передаётся адрес создателя, то будет указан адрес отправителя, в конце вызовется событие DocumentRegistered
68     с параметрами id - документа (позиция в массиве documents) и hash - хэш сумма */
69     function registerDocument(string hash,
70                        string link,
71                        string data) {
72         address creator = msg.sender;
73 
74         uint id = documentsCount + 1;
75         documentsIds[id] = Document({
76            hash: hash,
77            link: link,
78            data: data,
79            creator: creator,
80            date: now,
81            signsCount: 0
82         });
83         documentsCount = id;
84         DocumentRegistered(id, hash);
85     }
86 
87     /* функция добавления подписи в документ, параметры - ID Документа, адрес подписчика.
88     Если не передаётся адрес подписчика, то будет указан адрес отправителя,
89     в конце вызовется событие DocumentSigned */
90     function addSignature(uint id) {
91         address member = msg.sender;
92 
93         Document d = documentsIds[id];
94         uint count = d.signsCount;
95         bool signed = false;
96         if (count != 0) {
97             for (uint i = 0; i < count; i++) {
98                 if (d.signs[i].member == member) {
99                     signed = true;
100                     break;
101                 }
102             }
103         }
104 
105         if (!signed) {
106             d.signs[count] = Sign({
107                     member: member,
108                     date: now
109                 });
110             documentsIds[id].signsCount = count + 1;
111             DocumentSigned(id, member);
112         }
113     }
114 
115     /* Функция получения количества документов */
116     function getDocumentsCount() constant returns (uint) {
117         return documentsCount;
118     }
119 
120     /* Функция получения документа по ID */
121     function getDocument(uint id) constant returns (string hash,
122                        string link,
123                        string data,
124                        address creator,
125                        uint date,
126                        uint count) {
127         Document d = documentsIds[id];
128         hash = d.hash;
129         link = d.link;
130         data = d.data;
131         creator = d.creator;
132         date = d.date;
133     }
134 
135     /* Функция получения количества подписей по ID документа */
136     function getDocumentSignsCount(uint id) constant returns (uint) {
137         Document d = documentsIds[id];
138         return d.signsCount;
139     }
140 
141     /* Функция получения подписи документов, параметры - ID документа, позиция подписи в массиве */
142     function getDocumentSign(uint id, uint index) constant returns (
143                         address member,
144                         uint date) {
145         Document d = documentsIds[id];
146         Sign s = d.signs[index];
147         member = s.member;
148         date = s.date;
149 	}
150 }