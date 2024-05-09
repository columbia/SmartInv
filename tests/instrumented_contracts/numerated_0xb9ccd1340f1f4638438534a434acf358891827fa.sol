1 /**
2 ~~~~=~~~~~=~~~=~=~~~==~~======~~====~~~~~~~=~~==~=~==~~~~::~~::~::::::::::~~~:~~~~~~~==~~~++=~~~:=~::~:::~~~~=====~==~~~~:::~:~:=====+=~~~=~
3 ~~~~~~~~~~~~~~~~~~~~~~~:~~~=~::~=:=~~~~:~~~~~~~~~~~~~:~~::::~:::::,:::~~~~~~~~=~======~=+===~:~::~=~:::~::~~~~=:=====~~=~:~~~:~~~====~~~=~~~
4 ~==~==~~~~~~~:~~~~~~=:~~~:::~::~:~~::::::~~~::~:~:~~~~~~~=====~:~:::~:~~~~:~~~=====:~=~~===~~~~~::::~::::~~~~:~:===~====~~~~~~~~====~=====~~
5 ~=~~==~~====~~~~~~~~~=:~:~~~~:~~~~::~~::::::~::~~~:=~+7Z8DDDDDDD8ZI+?77???+I????=++++==~~=~=~::::~::,:~:::::::~:~~~~~~~~~~~~~::~~~==~~~=~===
6 =~~=~~~==~~=~~~=~~~==~:~~~~:~:~~:~::~~:::~:~=~=?IIODNNNNNNNNNNNNNNNDDDDNDDDDD88Z7?+++++~~:=~~::::~~~~:~::::::~~~~~======~~=~~=~~~~~~~~======
7 ~~~~~~~~~~~~:~~~~~~~~~~~~~~~~~~~~~~~=~~~=~~=7ODNNDNNDNNNNNNNNNNNNNNNDNNNNNNNNNNNNNND8$?+====~~~:~=~~:~~~:~:~:~~~~~~~~=~====~~~~=~~~~~~=====+
8 ~~~~:~~~:~~~~~~~~:~:~~~:~~~=~~~~~~~~~===I$8NNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNDZ?=~~~~~:~::::::::~::~::~:~:~===~~==~~~~~~~~~~=====~
9 ~~~~~~~~~~~~~~=:~~~:~:~~~~~~~::~:~~~~?78DDNNNNNNDNNNNNNNNNNNNNNNNNNNNDNNNNNNNNNNNNNNNNNNNDNO?==~~~~~::::~::,::::::~:~=~====?+===~~~:~~~~~~~=
10 ==~~~~~~~~=~~~~~~~~::::~::::::::~:=IZDNDNDNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNDDO+~+~~~~::~~:::=~~~~~~~~~======~==~~====~=====
11 ==~~~~~~~~~~~:~~~~~~::~~::::::~:~78DNNNNNNNNNNDDDNNNNNNNNNNNNNNNNNNNDDDDNNNNNNNNNNNNNNNNNNNNNNNDZ?=~:~::~::~::~:~:~:~~::~~~=~=======~~~==~~~
12 ~=~~~~~=~~~:::~:::~~~~~::~~~~~+INNDNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNDODNDNNNNNNNNNNNNNNNNNNNNNNNDNZ=~:::~::~~::::~:~:~~~~=~========~===~==~~
13 ==~~===~~~~~~::~~:~:~:::~~~~=?8DNNDNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNDDD8DDNNNNNNNNNNNNNNNNNNDNNNNNNNNNN++~~~~::~:~=~:~~:~~~~~~~=:====++==+==~~~
14 =======~~~~~~~~~::~~::,:::~=ZDNNNNNNNNNNNNNNNNNNNNNNNNNNMNNNNNDDDD88DDNNNNNNNNNNNNNNNMNNNNNNNNNNNNNNDZ=:~:~:~~=~::~~~~::::~~:::~~~==~~~==:~~
15 ~====~==~~~~~~~~:~::::::::=ONNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNDDDDDDDD8DNNNNNNNNNNNNMNNNNNNNNNNNNNDNNNDNO==~~:=~~:~::~:~~::~~~::~~=~~=========
16 =======~=~~~~~~~::~~:~:~=ZDNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNDDDDDNNDDDDDNNNNNNNNNNNNNNNNNDNNNNNNNNNNNNNDDO?~:~~~~~~::~~~~:~~::~:~~=~==:~~~~~=~
17 +====~~==~~~~~~::~~::~~?8DDDNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNDDDDDDDD8NDNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNND8?=~~::::~~~::~:~:~:~~~~~:~~~~======
18 ==========~~:::::::::~=8NNNNNNNNNNNNNNNNNNNNDNDNDNNNNDDDNDDD8DDDDD88DDDDDNNNNNNNNNDNNNNNNNNNNNNNNNNNNNDDND+~~~~~~~:~~~=~::=~~:~~::~~~~~~:~=~
19 ==~===~==~~~~::::::::=ODNNNNNNNNNNNNNNNNNNNNDDDNNNNDDDDNDDDODDDD8OO8D88DD8DDNDDNNNNNNDNNNNNNDNNNNNNNNNDDNND?=~~::~~~~~~:~:~~~~:~:~~~~~~~~:~=
20 ==~~~~~~~~~~~~~~~~:~~ZNDNNNNNNNNNNNNNNNNNDDDDDNDDDD88D8OOZ$8DD8OZ7$88ZOZ88ODDDDNDDNNDDDNDNNNDNNNNNNNNNNDDDND+:::~:~~~:~~=~~=~==~~==~~=~~~~~~
21 ======~~~~~~~~~~~~~=ZDNNNNNNNNNNNNNNNNNDD8O88D8D8D8D8Z$O777ZO777++7$7I$ZZZ$ZO8DDDDDDNNDDDNDDNDDNNNDDDNNNDDNN8?~~:~~~~=~~~~~~~~~~~~==~~~~~~~~
22 ====~~~~=~~~~:~~~==ZNNDNNNNNNNNNNNNNND8DZ888DDD8OD8O7II?I$ZI?+?+=+?Z?+I77II??7OD8DZDDDDD88DDDNNNNDNNNN8DDDDDD8+~::~::=:::~~~~===~===========
23 =~~~~~~~~=~~:~~~~~?NNNNNNNNNNNNNNNNDD88ZOO88DZZ88O7I?++I77=~~~+~~~?I~~~=+~+++?+Z8OOZDDDD88ODNNDDDDNDDDDNDDDDDDO=~~:::~::~~:===~~~~=~~~====~=
24 ~~=~~~~~~~~~~~~~~~ZNNNNNNNNNNNNNND8OOZ7$OOOOI7ZOZI??=7?I+~:::~~=:~++~~:=~:~?====$$O7I8DD8OO88D8DDDDDDNDNDDNDDNNO=~:::~:::~::~:~~=~~~~~===~==
25 =~=~~~~~~~~~~~~~~=8NNNNNNNNNNNNND88OZ$$ZZZO$$ZZ$I+?77$I:::::~:::::=~::,~:,:~~~~~=7OOI7Z888OZ88DNND8DDNNND8DDDNND+~::::~::~:~::~~~::~::~~~~=~
26 =~~~~~~====~~~===$NNNNNNNNNNDDDDDOO77$ZO877I??+==?II?=::,,~~:,,,,:~:~:,::::::~=~~=I$7=?$88OOZZO8DDDDODDDDDDDNNND8~~::~,:::,,:::~~~~:~~~=~~~~
27 ~~~~~~~~~~~~~~===ONNNNNNNNNNND88Z$$I$O88Z$?+=~~=+I?=:,:::::::,,,,:::,:::,,::,,~~,:~?7+=+$88O7$ZOD888O8DDDDDDNNND8I~~,::,::::~:~~:~:~~::~~~:~
28 ~~~~~~~~~~=~~~==?DNNNNNNNNNNDDD8$Z77O8DOI?+==~=7I~,,:,,,::,,,,,,,,,,:,::,,::,:::~~~~=I=~+7OOO$$7$D8ZOZ8DDNDNDDDDD8=~::::::~:::~~~~~~~=~~~~~~
29 ==~~~~~~~~~:~~~=ZNNNNNNNNNNDDD8ZZ777D8Z+=+~==II=:,,,,,,,,:,::,,,,,,,,,,:,::::::::~~~~+?~~+OIZ77IIZZ$Z$OODNDNDNNNNDI=:,~:::~:~:~~~~~~~::~~:~~
30 =~~~~~~~~~~~:~~+8DNNNNNNNNNND8OZ$$Z88I++===+I=~::,,,,,,,,,,,,:,,:,,.,,,,,,,,,,:,,,::~=?I=~+I?7II7IOZOOZ88DDNNNNNNDZ=~~~~~~=:~~::~~=~~~~=~~=~
31 ~=~~~=~~~~~~~~~?DNNNNNNNNNNND8OZ7OD87??+~~==::::,,,,,.,,,,,,,,,,:,,.,,,.,,,.:,:,,,,,::++==~+++?+I77Z8ZO7$8DNNNNNDN8=~===~~~~===~~~=~~~~=~~~=
32 ==~~~~~~~~~~~==IDNDDNNNNNNNDDDZ7ZDD$I7?==+=:,,,:,,,,,,,,,,,,,,:::,,,,:...,..,,,,,,.,,,:+?I+=~~=?=IZZ88Z$7$DNNNNDDDZ==~~:~::~~~~~:~===+======
33 ===~~~=~~~~~~==7DNNDNNNNNNNNDDO$OD$??+==~~:,,,,,,,,,,,,,.,,,,,,,,,,,,.,,,,,,,,,,,,,,.,,,:~+==~~+I=?7ZZ777$8NNNDDDDD?=~~~~~~====~~~~~:~~~~===
34 ~~~=~~~~~~~=~==ZNNNNNNNNNNNND8ZZ8$====+==~:,,,,,,,,,,,,,,.,,.,,,,,,::,.,,,.,,,,,,,...,,,,~~==~::=?=I7ZII??8NNNDDDDDI~~::~:,:::::~~:~~~~~~===
35 =~~=~~~~~~====+8NDNDNNNNNNNDND788?===~~~~::::,,,.,,,,,,,,,,,,,,,,,,,,,,,.,.,,,,,:,,,.,,...,~==::~==~=I??+ZDDDDDNDDDZ+~~~~~~~~:::~~:::::~=~~=
36 ~=~~~~~~~:~==+?8DNDNNNNNNNNNDD8D8I+=~==::,::::,,,,,,,::,:,,,,,.,,,,:,,,.,,..:,,,,.,...,.,,,,,~~:,:+~~~=7?78DDNNNNDNO=~,:,:::::::~~:~~:=~:~~=
37 ~~~~~~~~~~~~~=+8NDNNNNDNNDNNDDDDOI?==~~::::::,,,,,,,,,,,,,,,,.,:,,,:,,,,,,,,:,,,:::,,,.,,,,,:~::::~~,~=I?$8DDNDDNDD8+~~~~~::~::~~~:~~~~~~~==
38 ~~~~~~~~~~~~~=?DNNNNNDNNNNNNDDDD$I++=~=:::::,:,:,,,:,.,:,,,,,,,,..,,,,,,,,...,,,,,,.,..,,,:::::,:,,:~==+?ZD8DDDDDDDD=:,:::::~=~~:~~~~~~~~===
39 ~~~~~~~~~~~~:~+8NNNNDNDNNNNDD8D8I+==~~~:::,:,,,,:,,,.,..,,,,,,,.,,,,,,,,,,.,,,,,,,,,,,,,,.,:::::,,,:~~~??ODDDDNDDDD8+~::~~~::~~~~~~~~===~==~
40 ~~~~~~~~~~~~~~+ONNNDNNNNNDNDD8DZ+=====~::::::::,:,:,,,,.,,,,,:,,,,,.,::,,,,..,,,,,:,,,,,,,:::,,,,,,,:~~+?ODDDDDDDDD8I:::::~~~~~~~~~~~~~~====
41 ~~~~~~~~~~:~~~+8NNNNNNNNDDNN88O?+=~~~~~::::::,,,,,,,,,,,.,.,,,.,.,,,,:,,,,,:,,,,,::,,,,,,,,,,::::...,:~+I8DDDDDDDDD8?~~:::=~~==~~===~~~~~~~=
42 ~~~~~~~~~~~~~~+8NNNNNNNNDDD8OZ7+=====~~::::::::,,,,,,,,,,,,,,,,,,,...,,:,,,,,,,,,,,,.,,,,,,,::,,,,,,::~+?ZDDNDDDDDDD?~~~=~~~~~~~~~~~~~~=~=~~
43 ~~~~~~~~~~~~~~?DNNNNNNNNNND87?+=~=~:~:~:::::::,:,,:,,,:,,,,,,,,:,,,,,,,,,,::,,,,,,,::,:...,,,,:,,,,,,:~?+788NDDDDDDD?~~~~~~~~==~~~~~~:~~~~==
44 ~~~~~=~~~~~~~~+ZDDNNNNNNND8$?===~~~~~~~~~:::::::::,::,,,,,,,,,:,,,,,,,,,,,,,,,,,,,,,,,,,,,:,,::,:,,,,:~=+I8DDDDDDD8D?~~~~~~~~~~=~~~~~~~~~~~=
45 ~~~~~~~~~~~~~~+$$DDNNNNND8$7+====~=~~~~~~~::~~=~~~~=~~:::,:,,,:,,,:,,,,,,:,,,,..,,,:,,,,,,:~:::,,,,:,:~~=+$DDDDDDDDZ===~~~~~~:~~:~~~~==~====
46 ~~~~~~~~~:~~~~=II$DDDNNNDDZI===~~~~~~~~~~~::~~:~:~~~~::~::,,,,:,,,,,,,,,,,,,,.,,,,,:::~:::~~:~~~:,,,:~~~=~+88NDDNDDI~=~:~=~~~~~~=~~~~~======
47 ~~~~~~~~~::~~~~~==?8DNDDD8O?+=~~~~~~~~~~~~~~~::::::::~:~:~:~:,,:,:,::,,.,,,,,,.,,,::::::::~~~::::~:::~~~~~?8DDD87?$+~=~~~~~:~~~~~~======~===
48 ~~~~~~~~~~:~~~~~~~:~IDNNNDO?==~:~~=~:::~~~:::::::::,::,::~:::::,,,,::,,,,,:,,,,,,,:~:::::,,:,::,,::~:~~~~~=8DDD?:~=~~~~:~=~:~~~~~===+======~
49 ~~~~~~::~~~:~~~~++~:~ZDDD8Z?=~~:~~~~~~:::::::,,:::,:::,,:,:::,,:,,,,,,,,,,,,,.,,,,,:::,,,,:::::,::::,~~~~~+8DDI~~====~::::~~~~==~~===~=====+
50 ~~~~~~~:::::~:~~+=~::=8888Z?=~~~~~:~~~::::::::::,,,::::,,,::::,,,,,,:,,.,,,,:,:.,,,::,,,.::::,,,,,,::~~:::=8DD=~~=~~~~::~~~:~=+===~=:=~=~~~=
51 ~~~~::~:~::::::~~~~:,:?$ZOZ?=~~~~::~:::::::::::::::::::,,,,:::,:,:::,,,,,,,,,::,,,,::::,:,:::::::,,::~:~::~$O+~~~~~~:~::~~~~=+=====~~======+
52 ~~~~~~~~:~~~~~~~~~::,:~=+$Z?=~~~~:::::::~::::~=~=++++=~~~:::::,,,,:,,:,,,,,,,,,,,,,:::::::~~~~:,:::::::~::=I~:~====~~~::~~==+==~~::~~~===~=+
53 ~~~~~~~~~~~~~~~~~::,,:==+$$?=~~:~:::::::~::~~=?Z8DD8DD87+~::::::::,,,,,,,,.,:::,,,::~+IZO8O7+=~~::::::::,:~+::~~~~~~~~~~~~===+=~~~:~~~====++
54 ~~~~~:~~~~::~~~=Z7::,:~~=I$?=~~::::::,::::~~+$Z?$NIOD?7$~==~::::::,,,,:,,,,,,:::,,:=7$ID7I8I?ZO+:,,:::::,,:~::=~~~::::~====~~~~~~~~~======+=
55 ~~~~~~~~~:~::~=+ZDI:::~::~+?==:::::::::,:::~==~~+DDDO8DI:,:~::,,,,,,,,,,,.,,,:,,,:::+8D8888=:~=?=:,::::::,:::I?==~~~~:~~=~~=~:~~~~~~=~==+=~=
56 ~~~~~~~~:~~~~~~=I88=::~:::~+=~~::,::,,:,,:::::::~+O888+::::::,::::,,,:,,,,,,,,,,,,,::7888O?::~~:,,::,,,,,:::~DO=~~~~::======~~~~~~=========~
57 ~~~~~~~~:~~~~~=+Z8DO=::~::~==~~:::,,,,,:,,:::::::::~=~:::::::,:,::::,,:::,,,,::,,,,::~~~~,::::::,,,:::,,,:::7DDI~::~~~=~~~:~:=~=~===~===~=~~
58 ~~~~~~~~~~~~~~=$DDD8$:::=~~~=~~::,,,,,,,,,::::::::,:::,::::::,,,,:,,,,,:,,,.,,,,,,,:,::,,,::::::,::::::::~~7DND8=~::~~=~~~~~:~~~===~~~~~~~~=
59 ==~~~~~~~~~~~=?8DDDDNI:::~~:~~~:::,,,,,,,,,,,,::,,::::::::::,:,,,,,,,:,,,,,,,,,,,,,,::,,,,:,:,,,,,:,:,,:::INNDDO=~~~~===~~~~~========~~=====
60 ===~=~~~~~~~~~$NNDNDDD+:::::~~~~:::,,,,,,,,:,,,:::::::::,,,,::,,:,:::,,,:::,::,:,,,:,:,,,,,:::,,,,,::::::=DNNNNZ=~~~~=~:~~~~~===+~~~~~~====+
61 ====~~~~~~~~~=8DNNDDNND+~:,,:~~::::,,,,,,,,,,,,,:,:,::::,,,,,,,,,::::,,,,,:,::::,,,,:::,,,,::::,,:,:::::~ZDDNDD?:~~~==~~~~~:~===~~~=:~~==+=~
62 ======~~~~~~~+ONDNDDDDDZ=::::~~~~::,:,,,,,,,,,,,,::,,,,,,,,,,:,,,::,:,,,::,,:,::,,,,,::,,,::::,,,,:::,,:~$DNND8+~~~~=~:~~~~===+===~~~=~=++=~
63 =======~~~~~=+ONNNDNNND8+~::::=~:::,,,,,,,,,,,,,,,:,,,,,,,,,,,,,,,,:,,,,,,::::::,,,,,,,,,,,,,,,,,,::::::~ZNNDDDZ=~=~~=::~~==+==~=~~~====+===
64 =====~~~~~~~==7DDNNDDNND7~:::::~~::,,,,,,,,,,,,,,,,,,,,,,,:,,,::,,:::,,,,,::,,::::,,,:,,,,,,::,,,::::,,:~DDNNNDNI===~~:~~~~==~~~~~~~==++==~~
65 ====~=~~~~~~==+ZDDNDNNNDD+:::::~~~:::::,,,,,,,,,,,,,,,,,,:,,,::::::::,:,,,::::::::,,,:::,,,,:::,,::::::=ODNNNNNND?==~~~:~~=====~~~~==++==~~=
66 =====~~~~~==~~~?ONNDDNNDND?=~~:~=~::::,,:,,,,,:,,,,,,,,,:::,,:~:::::,:,,,:::::::::,,,,::,,,:,::,,::::~IDNDNNNNNNN$+=~~~~=====~~~~=======~===
67 ==========~~~=++$DDNNNNNNNNNO$7I?=~:::,,,,,,,,,::,,,,,,,,,::::::::,::,:,,,,::::::::,,::,,,:,:,,,,::~:=DDNNNNNNNNNO+~~~=~~~~=~~=~~=======~==+
68 ===~======~~~+?ONNNNNNNNNNNDNNNDD?=~~:::::,,,,,:,,,,,::,,:::::::::,,::,,,,:::::::::,,::,,,,,,:,,,:::~+NNNNNNNNNDN$=~::~====~~~=+~====~~==+++
69 ========~===++$DNNNNNNNNNNNNNNNNNO+~~:::,,:::,,,,,,,,:,::::::::::::,,,,,,,:::::::::,,::,,,,::::,,::~=$NNNNNNNNNND?=~~:====~~~======~~~===+=+
70 ======~~~~===IDNNNNNNNNNNNNNNNDDD8$~~:::,,:::,,,::,:,,::::::::,::::::::::::::~:::::,::::,,,:::,,,:~~+DNNNDNNNNDD7==~:~====~~~=====~==~==+++=
71 ++=+==~====+?ZNNNNNNNNNNNNNNDNDNDD$=~:::::::,:,:,:::,,::,,:::::~==~~:~~::::~~~:::::::::::,,:::,:,::~7DDNNNNNNNNNZ+=~~~====~~~===========++=+
72 +++========+?ONNNNNNNNNNNNNNNDDDD7?+~~::::::::::::,:,:::::::::::::~~::~~::::~:::::::,:::::,:::::,:~=8NNNNNDNNNNNN$=~~~====~~==+===~======++=
73 ++++=+=====+?ZNNNNNNNNNNNNNNNNNNNI+==~:::::::::,:::::::::,:::,,,::::::::::::::::::::,:::,,,:::::::=INNNNNDNNNNNNN8+~~===~=~~~=====~=+=+=====
74 ++++++=+===++ZNNNNNNDDNNNNNNNNNNN$+==~::::::::::::,,::::::,::,,:::::,::::,::::::::::,:::,::,:::::~=8DNNDNDNNNNNNND?~===~~~~~=====~~=++=+===+
75 ++++++======+7NNNNNNNNNNNNNNNNNNNO?===~::::::::::::::::::::::::::::::,:,:,::::::::~~::::::,:::,::~IDNNDNNNNNDNNNNN+===~=~~===+==~===++=+==++
76 +++++=======+?ODNNNNNNNNNNNNNNNND$?====~~:::::::::,:::::::::::::::::,,:::::::~~~=++~:::::,::::::~=?DDNNNNNNNNNNNN8+===~~~~==+==~===++++===+?
77 +++++========?8NNNNNNNNNNNNNNNNNO?++====~~::::::::::::::~==++=+==~~~~~~~~=~~+O7I?+=~~,:::,::::::~=?$NNNNNNNNNNNNN7===+~~==++=~~~===++===++++
78 +++++++=====++?$777Z8DDNNNNNNND$+=++=====~~~::::::::::::~~~=++I7+=~~~~:~~??+=+=~~~~~:::::::::::~~++?ODNNNDNNNDN8I~~===~~===+=~~~++++====?+++
79 +++=+=+=======~:::::~=?8NNNN87?+=======~==~~::::::::::::::::::~~~:~:~~::~~~:~~~~:::::::::::::~~~==+++?ONNNND8?=~:~===========~====+====+?+++
80 +++++=========~~~:~~~=+ION87+====~~======~===~~::::::::::::::::::::,:,::::::~~~:::::,:::::::~==~~===~=+7OD8$?+$OD8~~==~=+=======+=+==+=+?+?=
81 ++++=+========?8DDDDD8Z$$I=====~=~~=======++=~~~:::::::::::::::::::::::::::::~~::::::,::~::~==~~~~=~~~=+?$7ODDD87=~~====+~==~~=+=+++==++?++=
82 ++=+======+++?8NNNNNNNND7+====~~====~~==~==+==~~~~:::::::::::,::::::~::::~~:::::::::::::~~~~~=~~~~=~~====+7$88$I?7O88$?+++==~==++===++++++++
83 ?+++===+++?7ZDNNNNNNNNNN8I===========~=====+++==~~~~:::::::::,,:::::::::::::::::::::::~~~=~~~~~~~=~~~~~==~=IOD8NNNNNNDDDO$I?+=+++===+???++=+
84 +?+++++?IZ8NNNNNNNNNNNNNDDZI?+====+======~=++====~~~:::::::::,:,:::::::::::::::::::~~::~==~~~~~~~==~~=~====+8DNNNNNNNDNDNDDDZ$III==++????+++
85 ????II7Z8NNNNNNNNNNNNNNNNNNDZ7?++====~==~~=+?+===~~=~~::::::::::::,,::::::,:::::::::~~~~=+=~~=~~~=======~~=I8NNNNNNDNNNDNNNNNDDD8888ZZ$7??+?
86 ??I?$O8NNNNNNNNNNNNNNNNNNNNDNN8$?=========+??==~~=~~~~:::::::::,::,,,:::::,::::::::~~~~~~+?======+?+=++===+ZDNNNNNNDDDDNNDNDNNNDDDDOOO$7I??I
87 ??I7ODNNNNNNNNNNNNNDDNNNNNNNNNNDOI?+=====+II?+=~~~~~~~~~:::::::::,,::::::::::::::~~~::~~~=??+++?+???===+++IONNNDNNNDDDNDNDNNNNNDDDDN887$7I?+
88 II$ODNNNNNNNNNNNNNNNDNNNNNNNNNNNNDZ+====?$7?++~~~~~~:~~~~~~~:::::::::::::::::::::::::::~~+?I$OZ77ZO$I++++?$DNNNNNNNDNDDDDDDDDNNNNNNNDD8Z$7?+
89 ?7ODNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNI+?7O8O7?++=~~~~~:::::~~~:~:~:::::::~:::~~~:::::::::~~=+?Z8DDD8ND$$III?ZNNNDNNDNNDDDDDDDDNNNNDNNNNDDD$II?
90 IZ8NDNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNDDD88O$I?+==~:~~~:::::::::::~~~~~~~~~~~~~~::::::::::~===?I888DDDDD8OZ$ZDNNNNNNNDDDDDN8DDNNNNNNNDNNDNDDZI+
91 7ZDNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNDD8O7I+===~~~:~:::::::~:::~::::::~~:::~::::::::::::~=~+I8DNDDDNNNNNDNNNNNNNNNNDNNNNNDNNNNNNDNDNNDDNDD$I
92 $ZDNNNNNNNNNNNNNNNNNNNNNNNDNNNNNNNNDNDDDZI+==~~~~~~~~:::~::::::::::::::::::::::~::::::~~~===?ODDNNNNNNNNDNNNNNNNNNNNNNNNNNDNNDNNNNNNNNDNNDO7
93 7ZDNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNND8$I=~~~~~~~:~:~:~::::::::::::::::::::::::~::::~~~~~~~=I8DNNNNNNNNNNNNNNNNNNNDNNDNNDNDDDNNNNDNNNDDND8$
94 7ZDNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNDD8O7+=~~~~~~~~:::~~::::::::::::::::::::::::::~::~::~~~~~+I7DNNNNNNNNNNNNNNNNNNDNNDNNNNNDDDNNNNNNNDDDD8$
95 7ZDNNNNNNNNNNNNNNNNNMNNNNNNNNNNNNNNNDD8$I+~~~~::~~~~~~:~~:~::::::::::::::::::::::::::~~:~~:~~=?I78DDDNNNNNNNDNNNNNNNDNDNNNNDDNNNNNNNNNDDDDD$
96 I$ODNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNND8OI++~~~~~~~~:::~:~::::::::::::~::::::::::::::::~~~:~~~~~=~+?7IZDDNNNNNNNNNNNNNNNNNNNNDDDNNNNNDNNNNNNO7
97 I7ZDNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNND8Z?==~~~~~~:::::~:::::::::::::::::::~:::::::~::~~:~~~~:~=?===~~~+$DNNNNNNNNNNNNDNNDNNDNNNDNNND88DDNNDZ7
98 III$8NNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNDZ7+=~~~~:~:::::::::::::::::::::~::~~:::::::::~~:~:::~:~~++~~~::::~+I8DNNNNNNNNNNNNNNNNNNNNNNNDD8DDNND7I
99 $I??78NNNNNNNNNNNNNNNNNNNNNNNNNNNDDDZI+=~~~~~~~~~:~~~~:~:::::::::::~::~:~:~::~~~~~~:~::::~~~~?=~=~::::::~+78DNNNNNNNNNNNNDDNNNNNNNDD8DDN8O7I
100 ZI???$ONDDNNNNNNNNNNNNNNNNNNNND8OZ$$?+=~~~~~~~~~:~~~~~:::::::::~~:::~~~~~~~~::~~~:::~::::=~:~?+=~~:::::::~=IZDDNNNDNNNDDNDDDNNNNDDDDDDDDZ7II
101 II+++?IZ8D88DDNNNNNNNNDDD888O$ZZ$???+==~~~~~~~~~~~~~~~~~:::~:~:~~:~:::~~~~~~~~~:~~~:~:~~:~~~+=~~~~:::::::~==?$77I?7$ZZZZ7II7O8OODD8D8OZ$7III
102 ??++=++I7ZZOZ$$$$$$$$IIII??++++?+==??=~~=~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~=++===~~::::::~~~~=~~:::~=====~~~+??7$OZ7IIIIIIII
103 ?+===+=+??I??=++===++==~==~~====+===+======~~~~~~~~~~~~~~~~~~~~~:~~~~~~~~~~~~~~~~~~~:~~::~~++~==~:~:~~:::~~~~~~~:::::~~~~~~~==I7II?+++?IIIII
104 +++++===++++===========~~~~~~~=====++=====~~~=~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~++===~~~:~~~::~~~~~~::~~:~::~~~~~~~=+??+===++??II
105 ?++=+====+============~~~~=~=====+=====~==~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~====~~~~::~:::~~~~~~::~~~:::~::~~~~+?===~=~===+?I
106 +++++======================~==~~===+==~=~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~=~~~===~~~~~~~~~~~~==~==~~~~~~~~~~~~~~~~~::~~~~~~~~~~~=++?+======++?
107 +++====+++=================~=~~~===++==~=~~~~~~~~~~~~~~~~~~~~~~~~~~~=~~~~~~~~~~~~~~~~~~~~~~=++==~~~~~~~~~~~~~~=~~~~~~~~~~~~~~~=++==+=====+++
108 ?+++++=+++===================~====+==+====~====~~~~~~~~~~~~=~~~~~~~=~~=~~~~~~~===~~~~~~~~~==~+=~~~~~~~~~~~=~~==~~~~~~~~~~~~====?+=+++=====++
109  */
110 
111 /**
112  * Created on 2018-08-16 03:50
113  * @summary
114  * Don't let 'em say you ain't beautiful.
115  * They can all get fucked.
116  * Just stay true to you.
117  * @author yong
118  */
119 pragma solidity ^0.4.23;
120 
121 
122 library SafeMath {
123 
124     function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
125         if (a == 0) {
126             return 0;
127         }
128 
129         c = a * b;
130         assert(c / a == b);
131         return c;
132     }
133 
134     function div(uint256 a, uint256 b) internal pure returns (uint256) {
135         return a / b;
136     }
137 
138     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
139         assert(b <= a);
140         return a - b;
141     }
142 
143     function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
144         c = a + b;
145         assert(c >= a);
146         return c;
147     }
148 }
149 
150 contract Ownable {
151   address public owner;
152 
153 
154   event OwnershipRenounced(address indexed previousOwner);
155   event OwnershipTransferred(
156     address indexed previousOwner,
157     address indexed newOwner
158   );
159 
160   constructor() public {
161     owner = msg.sender;
162   }
163 
164   modifier onlyOwner() {
165     require(msg.sender == owner);
166     _;
167   }
168 
169   function renounceOwnership() public onlyOwner {
170     emit OwnershipRenounced(owner);
171     owner = address(0);
172   }
173 
174   function transferOwnership(address _newOwner) public onlyOwner {
175     _transferOwnership(_newOwner);
176   }
177 
178   function _transferOwnership(address _newOwner) internal {
179     require(_newOwner != address(0));
180     emit OwnershipTransferred(owner, _newOwner);
181     owner = _newOwner;
182   }
183 
184 }
185 
186 contract ERC20 is Ownable {
187 
188     using SafeMath for uint256;
189 
190     event Transfer(address indexed from, address indexed to, uint256 value);
191     event Approval(address indexed owner, address indexed spender, uint256 value);
192 
193     mapping(address => uint256) balances;
194     mapping (address => mapping (address => uint256)) internal allowed;
195 
196     uint256 totalSupply_;
197 
198     function ()
199         public
200         payable {
201     }
202 
203     function totalSupply() public view returns (uint256) {
204         return totalSupply_;
205     }
206 
207     function transfer(address _to, uint256 _value) public returns (bool) {
208         require(_to != address(0));
209         require(_value <= balances[msg.sender]);
210 
211         balances[msg.sender] = balances[msg.sender].sub(_value);
212         balances[_to] = balances[_to].add(_value);
213         emit Transfer(msg.sender, _to, _value);
214         return true;
215     }
216 
217     function balanceOf(address _owner) public view returns (uint256) {
218         return balances[_owner];
219     }
220 
221     function transferFrom(
222         address _from,
223         address _to,
224         uint256 _value
225     )
226         public
227         returns (bool)
228     {
229         require(_to != address(0));
230         require(_value <= balances[_from]);
231         require(_value <= allowed[_from][msg.sender]);
232 
233         balances[_from] = balances[_from].sub(_value);
234         balances[_to] = balances[_to].add(_value);
235         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
236         emit Transfer(_from, _to, _value);
237         return true;
238     }
239 
240     function approve(address _spender, uint256 _value) public returns (bool) {
241         allowed[msg.sender][_spender] = _value;
242         emit Approval(msg.sender, _spender, _value);
243         return true;
244     }
245 
246     function allowance(
247         address _owner,
248         address _spender
249      )
250         public
251         view
252         returns (uint256)
253     {
254         return allowed[_owner][_spender];
255     }
256 
257     function increaseApproval(
258         address _spender,
259         uint _addedValue
260     )
261         public
262         returns (bool)
263     {
264         allowed[msg.sender][_spender] = (
265             allowed[msg.sender][_spender].add(_addedValue));
266         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
267         return true;
268     }
269 
270     function decreaseApproval(
271         address _spender,
272         uint _subtractedValue
273     )
274         public
275         returns (bool)
276     {
277         uint oldValue = allowed[msg.sender][_spender];
278         if (_subtractedValue > oldValue) {
279             allowed[msg.sender][_spender] = 0;
280         } else {
281             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
282         }
283         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
284         return true;
285     }
286 
287     function withdraw()
288         public
289         onlyOwner {
290         msg.sender.transfer(address(this).balance);
291     }
292 
293 }
294 
295 
296 contract ERC223ReceivingContract { 
297     function tokenFallback(address _from, uint _value, bytes _data) public;
298 }
299 
300 
301 contract ERC223 is ERC20 {
302 
303     function transfer(address _to, uint256 _value)
304         public
305         returns (bool) {
306         require(_to != address(0));
307         require(_value <= balances[msg.sender]);
308 
309         bytes memory empty;
310         uint256 codeLength;
311 
312         assembly {
313             codeLength := extcodesize(_to)
314         }
315 
316         balances[msg.sender] = balances[msg.sender].sub(_value);
317         balances[_to] = balances[_to].add(_value);
318         if(codeLength > 0) {
319             ERC223ReceivingContract receiver = ERC223ReceivingContract(_to);
320             receiver.tokenFallback(msg.sender, _value, empty);
321         }
322         emit Transfer(msg.sender, _to, _value);
323         return true;
324     }
325 
326     function transferFrom(
327         address _from,
328         address _to,
329         uint256 _value)
330         public
331         returns (bool) {
332         require(_to != address(0));
333         require(_value <= balances[_from]);
334         require(_value <= allowed[_from][msg.sender]);
335 
336         bytes memory empty;
337         uint256 codeLength;
338 
339         assembly {
340             codeLength := extcodesize(_to)
341         }
342 
343         balances[_from] = balances[_from].sub(_value);
344 
345         if(codeLength > 0) {
346             ERC223ReceivingContract receiver = ERC223ReceivingContract(_to);
347             receiver.tokenFallback(msg.sender, _value, empty);
348         }
349 
350         balances[_to] = balances[_to].add(_value);
351         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
352         emit Transfer(_from, _to, _value);
353         return true;
354     }
355 
356 }
357 
358 
359 /**
360  * ╔╗░░╔╦╗░░╔╗╔╗░░░░░░░░░░░░╔═══╦╗░╔╗░░░░░░░
361  * ║╚╗╔╝║╚╗╔╝║║║░░░░░░░░░░░░║╔═╗║║░║║░░░░░░░
362  * ╚╗╚╝╔╩╗╚╝╔╝║║░░╔══╦╗╔╦══╗║║░╚╣╚═╣║╔══╦══╗
363  * ░╚╗╔╝░╚╗╔╝░║║░╔╣╔╗║╚╝║║═╣║║░╔╣╔╗║║║╔╗║║═╣
364  * ░░║║░░░║║░░║╚═╝║╚╝╠╗╔╣║═╣║╚═╝║║║║╚╣╚╝║║═╣
365  * ░░╚╝░░░╚╝░░╚═══╩══╝╚╝╚══╝╚═══╩╝╚╩═╩══╩══╝
366  */
367 contract Chloe is ERC223 {
368 
369     string public constant name = "Shuhan Liao";
370     string public constant symbol = "Chloe";
371     uint8 public constant decimals = 0;
372     string public message;
373 
374     /* constructor */
375     constructor()
376         public {
377 
378         totalSupply_ = 2;
379         balances[owner] = totalSupply_;
380         emit Transfer(0x0, owner, totalSupply_);
381 
382         message = "Happy Valentines Day!";
383     }
384 }