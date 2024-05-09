1 pragma solidity 0.4.18;
2 
3 /**
4  * @title BET WEA, apuestas criptograficas
5  * @author  WEA CEO
6  * @version 1.0
7  *
8  * @section LICENSE
9  * Contrato con registros en DIBAM, Santiago de Chile,
10  * cualquier uso, copia u  ramificación de este código está
11  * estrictamente prohibido, así como también el código del
12  * frontend que resulte de mencionado contrato.
13  *
14  */
15 
16 
17 /** ERC20 contract according OZ solutions **/
18 contract ERC20 {
19     function transfer(address _to, uint256 _value) public returns(bool);
20     function balanceOf(address tokenOwner) public constant returns (uint balance);
21     function transferFrom(address from, address to, uint tokens) public returns (bool success);
22 }
23 
24 /** ERC20 contract according OZ solutions **/
25 
26 contract BetWEA {
27 //0xd8e64769bb02136564737a4ecc712083b473db86, 1527353100
28 
29 /**
30 *@section CONSTRUCTORS
31 *@param limit set timestamp end time.
32 **/
33     function BetWEA(address _tokenAddr, uint _limit) public { //RECORDAR USR _LIMIT
34         tokenAddr = _tokenAddr;
35         token = ERC20(_tokenAddr);
36         limit = _limit;
37         owner = msg.sender;
38     }
39 
40     // Modifers
41     modifier onlyOwner() {
42     require(msg.sender == owner);
43     _;}
44 
45     // Variables globales
46     address public tokenAddr = 0x0;
47     ERC20 token;
48     address public owner;
49     address[]  ParticipantesA;
50     address[]  ParticipantesB;
51     uint maximo;
52     uint public winnerid;
53     uint public minimowea = 10000;
54     uint public limit;
55     uint r = 0; //define el estado
56     uint public precioether = 2000000000000000; //0.002
57     uint public discount = 60; //0.0012 or 1200000000000000 40%
58     uint public percent = 95; // lo que se queda
59     uint public Wp= precioether*discount/100;
60     uint public preciowea = 10000;
61 
62 /**
63 *@section SETTERS OF BET
64 **/
65     function ChooseA() public payable {
66        require((r==0) && (now < limit));
67        if(token.balanceOf(msg.sender) > minimowea){
68            require(msg.value == Wp);
69            ParticipantesA.push(msg.sender);
70        } else {
71           require(msg.value == precioether);
72           ParticipantesA.push(msg.sender);
73        }
74     }
75 
76     function ChooseB() public payable {
77        require((r==0) && (now < limit));
78        if(token.balanceOf(msg.sender) > minimowea){
79            require(msg.value == Wp);
80            ParticipantesB.push(msg.sender);
81        } else {
82           require(msg.value == precioether);
83           ParticipantesB.push(msg.sender);
84        }
85     }
86 
87     //Pay with WEA
88      function ChooseAwea() public {
89         require((r==0) && (now < limit));
90         require(token.transferFrom(msg.sender, this, preciowea));
91         ParticipantesA.push(msg.sender);
92 
93     }
94 
95     function ChooseBwea() public {
96         require((r==0) && (now < limit));
97         require(token.transferFrom(msg.sender, this, preciowea));
98         ParticipantesB.push(msg.sender);
99 
100     }
101 
102     function setWinner(uint Resultado) public onlyOwner { // 1 A, 2 B
103      uint  ethtransfer = this.balance*percent/100;
104      require(r == 0);
105         if(Resultado == 1){
106             maximo = ParticipantesA.length;
107             winnerid = rand(maximo);
108             r = 1;
109             token.transfer(ParticipantesA[winnerid], token.balanceOf(this));
110             ParticipantesA[winnerid].transfer(ethtransfer);
111 
112         } else if(Resultado == 2) {
113             maximo = ParticipantesB.length;
114             winnerid = rand(maximo);
115             r = 2;
116             token.transfer(ParticipantesB[winnerid], token.balanceOf(this));
117             ParticipantesB[winnerid].transfer(ethtransfer);
118 
119         } else { revert();}
120     }
121 
122 
123 /**
124 *@section OTHERS SETTERS
125 **/
126     function Clean() public onlyOwner {
127     ParticipantesA.length = 0;
128     ParticipantesB.length = 0;
129     winnerid = 0;
130     r = 0;
131     }
132 
133     function setLimit(uint _limit) public onlyOwner {
134         limit = _limit;
135     }
136 
137     function setNEW(address _tokenAddr,
138     uint _preciowea,
139     uint _precioether,
140     uint _discount,
141     uint _minimowea) public onlyOwner {
142         tokenAddr = _tokenAddr;
143         precioether = _precioether;
144         preciowea = _preciowea;
145         discount = _discount;
146         minimowea = _minimowea;
147 
148     }
149 
150     function sacarETH() public onlyOwner {
151         owner.transfer(this.balance);
152     }
153 
154     function sacarWEA() public onlyOwner {
155         token.transfer(owner, token.balanceOf(this));
156     }
157 
158 /**
159 *@section GETTERS
160 **/
161 
162     function getParticipantesA() view public returns(address[]) { //Necesario para obtener los datos
163         return ParticipantesA;
164     }
165 
166     function getParticipantesB() view public returns(address[]) { //Necesario para obtener los datos
167         return ParticipantesB;
168     }
169 
170     function getWinner() view public returns(address) {
171         if(r == 1){
172         return ParticipantesA[winnerid];
173         } else if(r==2){
174             return ParticipantesB[winnerid];
175         } else { revert(); }
176     }
177 
178 /**
179 *@section FALLBACK
180 **/
181     function() public payable {
182     }
183 
184 /**
185 *@section RANDOM NUMER
186 *@param rand returns into max numer of random
187 **/
188     uint256 constant private FACTOR =  115792089;
189     function rand(uint max) constant private returns (uint256 result){
190         uint256 factor = FACTOR * 100 / max;
191         uint256 lastBlockNumber = block.number - 1;
192         uint256 hashVal = uint256(block.blockhash(lastBlockNumber));
193         return uint256((uint256(hashVal) / factor)) % max;
194     }
195 }