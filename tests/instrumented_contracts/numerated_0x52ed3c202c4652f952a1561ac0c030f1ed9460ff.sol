1 /*
2 AvatarNetwork Copyright
3 
4 Подпись документов v1.2
5 
6 
7 https://avatarnetwork.io
8 
9 */
10 
11 /* Родительский контракт */
12 contract Owned {
13 
14     /* Адрес владельца контракта*/
15     address owner;
16 
17     /* Конструктор контракта, вызывается при первом запуске */
18     function Owned() {
19         owner = msg.sender;
20     }
21 
22     /* Изменить владельца контракта, newOwner - адрес нового владельца */
23     function changeOwner(address newOwner) onlyowner {
24         owner = newOwner;
25     }
26 
27     /* Модификатор для ограничения доступа к функциям только для владельца */
28     modifier onlyowner() {
29         if (msg.sender==owner) _;
30     }
31 
32     /* Удалить контракт */
33     function kill() onlyowner {
34         if (msg.sender == owner) suicide(owner);
35     }
36 }
37 
38 /* Основной контракт, наследует контракт Owned */
39 contract Documents is Owned {
40 
41     /* Структура представляющая документ */
42     struct Document {
43         string hash;
44         string link;
45         string data;
46         address creator;
47         uint date;
48         uint signsCount;
49         mapping (uint => Sign) signs;
50     }
51 
52     /* Структура представляющая подпись */
53     struct Sign {
54         address member;
55         uint date;
56     }
57 
58     /* Маппинг ID документа -> документ */
59     mapping (uint => Document) public documentsIds;
60 
61     /* Кол-во документов */
62     uint documentsCount = 0;
63 
64     /* Событие при подписи документа участником, параметры - адрес участника, ID документа */
65     event DocumentSigned(uint id, address member);
66 
67     /* Событие при регистрации документа, параметры - ID документа */
68     event DocumentRegistered(uint id, string hash);
69 
70      /* Конструктор контракта, вызывается при первом запуске */
71     function Documents() {
72     }
73 
74     /* функция добавления документа, параметры - хэш, ссылка, дополнительные данные, создатель.
75     Если не передаётся адрес создателя, то будет указан адрес отправителя, в конце вызовется событие DocumentRegistered
76     с параметрами id - документа (позиция в массиве documents) и hash - хэш сумма */
77     function registerDocument(string hash,
78                        string link,
79                        string data) {
80         address creator = msg.sender;
81 
82         uint id = documentsCount + 1;
83         documentsIds[id] = Document({
84            hash: hash,
85            link: link,
86            data: data,
87            creator: creator,
88            date: now,
89            signsCount: 0
90         });
91         documentsCount = id;
92         DocumentRegistered(id, hash);
93     }
94 
95     /* функция добавления подписи в документ, параметры - ID Документа, адрес подписчика.
96     Если не передаётся адрес подписчика, то будет указан адрес отправителя,
97     в конце вызовется событие DocumentSigned */
98     function addSignature(uint id) {
99         address member = msg.sender;
100         if (documentsCount < id) throw;
101 
102         Document d = documentsIds[id];
103         uint count = d.signsCount;
104         bool signed = false;
105         if (count != 0) {
106             for (uint i = 0; i < count; i++) {
107                 if (d.signs[i].member == member) {
108                     signed = true;
109                     break;
110                 }
111             }
112         }
113 
114         if (!signed) {
115             d.signs[count] = Sign({
116                     member: member,
117                     date: now
118                 });
119             documentsIds[id].signsCount = count + 1;
120             DocumentSigned(id, member);
121         }
122     }
123 
124     /* Функция получения количества документов */
125     function getDocumentsCount() constant returns (uint) {
126         return documentsCount;
127     }
128 
129     /* Функция получения документа по ID */
130     function getDocument(uint id) constant returns (string hash,
131                        string link,
132                        string data,
133                        address creator,
134                        uint date) {
135         Document d = documentsIds[id];
136         hash = d.hash;
137         link = d.link;
138         data = d.data;
139         creator = d.creator;
140         date = d.date;
141     }
142 
143     /* Функция получения количества подписей по ID документа */
144     function getDocumentSignsCount(uint id) constant returns (uint) {
145         Document d = documentsIds[id];
146         return d.signsCount;
147     }
148 
149     /* Функция получения подписи документов, параметры - ID документа, позиция подписи в массиве */
150     function getDocumentSign(uint id, uint index) constant returns (
151                         address member,
152                         uint date) {
153         Document d = documentsIds[id];
154         Sign s = d.signs[index];
155         member = s.member;
156         date = s.date;
157 	}
158 }