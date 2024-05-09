1 pragma solidity 		^0.4.25	;							
2 											
3 	contract	VOCC_I043_20181211				{					
4 											
5 		mapping (address => uint256) public balanceOf;									
6 											
7 		string	public		name =	"	VOCC_I043_20181211		"	;	
8 		string	public		symbol =	"	VOCC_I043_20181211_subDT		"	;	
9 		uint8	public		decimals =		18			;	
10 											
11 		uint256 public totalSupply =		19800000000000000000000000					;		
12 											
13 		event Transfer(address indexed from, address indexed to, uint256 value);									
14 											
15 		function SimpleERC20Token() public {									
16 			balanceOf[msg.sender] = totalSupply;								
17 			emit Transfer(address(0), msg.sender, totalSupply);								
18 		}									
19 											
20 		function transfer(address to, uint256 value) public returns (bool success) {									
21 			require(balanceOf[msg.sender] >= value);								
22 											
23 			balanceOf[msg.sender] -= value;  // deduct from sender's balance								
24 			balanceOf[to] += value;          // add to recipient's balance								
25 			emit Transfer(msg.sender, to, value);								
26 			return true;								
27 		}									
28 											
29 		event Approval(address indexed owner, address indexed spender, uint256 value);									
30 											
31 		mapping(address => mapping(address => uint256)) public allowance;									
32 											
33 		function approve(address spender, uint256 value)									
34 			public								
35 			returns (bool success)								
36 		{									
37 			allowance[msg.sender][spender] = value;								
38 			emit Approval(msg.sender, spender, value);								
39 			return true;								
40 		}									
41 											
42 		function transferFrom(address from, address to, uint256 value)									
43 			public								
44 			returns (bool success)								
45 		{									
46 			require(value <= balanceOf[from]);								
47 			require(value <= allowance[from][msg.sender]);								
48 											
49 			balanceOf[from] -= value;								
50 			balanceOf[to] += value;								
51 			allowance[from][msg.sender] -= value;								
52 			emit Transfer(from, to, value);								
53 			return true;								
54 		}									
55 											
56 											
57 											
58 //	}										
59 											
60 											
61 											
62 											
63 											
64 											
65 											
66 											
67 											
68 											
69 											
70 											
71 											
72 											
73 											
74 											
75 											
76 											
77 											
78 											
79 											
80 //	NABCHF										
81 											
82 //	  < # ; REF ; Month ; Optionchain ; Chart ; Last ; T(-1) ; Change ; BAS_1 ; BAS_2 ; Prior. Settle ; Open ; High ; Low ; Volume ; Hi / Lo ; Updated (s) ; Code ; @ eth_hex ; @ btc_882 >										
83 											
84 //	        < 0 ; T0 ; - ; - ; - ; 0 ; 1,14 ; -1 ; - ; - ; - ; - ; - ; - ; - ; - ; - ; - ; FD28Bf2C6FFDcfdD1A8BC7CcAaAbd5Ac7a87d4CebDadbC9abB2dEbdcAE79F784 ; < k2SR6nfbN2EJ6b2AMWmk65z9T6IqW0Op4GunR162OoXfxchdC4T48T3tG6791U8t > >										0
85 //	        < 1 ; 0M ; JAN 2019 ; opt. ; - ; 0 ; 1,14022012829845 ; -1 ; -0,00025 ; 0,00025 ; 5,5 ; -8,3 ; 9,1 ; -7,1 ; 4,8 ; -1,1 ; 0,59 ; NABCHF93JA19 ; 4baCAA8CFF9BDadE35feA82cC35DaCCA933cFbACacA6dEfE5cE67C9EDAFEeeee ; < B3Os41Ck3UlIYn6efoHq8G439a27R3vltA2LwSDk8gu5q99L42kNicW3OR09k4rR > >										1
86 //	        < 2 ; 2M ; MAR 2019 ; opt. ; - ; 0 ; 1,14079278481714 ; -1 ; -0,00025 ; 0,00025 ; -4,3 ; 0,4 ; 1,5 ; 6,9 ; -2,1 ; -2,7 ; -0,15 ; NABCHFMA1971 ; 7B7DA8CefD8fDfc4cA3f3F04Dfb8C110Af2DFF0D53Ca2d676E638dEe4ED70DD2 ; < 4438Dh6rRPL218n73F05GcN4X626kuVFWqLH3GY0C64RkNeebumBH0sHHbXGz8o2 > >										2
87 //	        < 3 ; 4M ; MAY 2019 ; opt. ; - ; 0 ; 1,14142639814536 ; -1 ; -0,00025 ; 0,00025 ; -6,5 ; 2 ; 2,1 ; -2,3 ; -3,9 ; 4,1 ; 0,1 ; NABCHFMA1948 ; df9fcacB6c9E34Eb7DffC5Aba03a0d0bAceAffe866e7eF1fAb35e6eb811f8ce2 ; < EeuSGuN854799iqt5O4rP19N6nHrlte57b6vPWQTDQuinp9Flq9ersdZX27ikF9t > >										3
88 //	        < 4 ; 6M ; JUL 2019 ; opt. ; - ; 0 ; 1,14237451239954 ; -1 ; -0,00025 ; 0,00025 ; -5 ; -4,9 ; 1,4 ; -1,8 ; -0,8 ; 3,2 ; -0,87 ; NABCHFJU1924 ; 67EBD1Ea5CeC54c7b3daBC0c0f98630653C14faeAdDD1baF7DCEc49aD8bacea4 ; < hX151v3CmklD8T45e1PVeaA84qBqs8GWnva2gfnzZ23O394m1dU1bqTdhf1UI9uc > >										4
89 //	        < 5 ; 8M ; SEP 2019 ; opt. ; - ; 0 ; 1,14346880221948 ; -1 ; -0,00025 ; 0,00025 ; -8,2 ; 1,5 ; -3,7 ; -4,9 ; 4,5 ; 3,3 ; -0,73 ; NABCHFSE1987 ; BEDb9ACaf62f7821BDA4b438Df40Bfa3AE7d8acD2FCC6debfccC6aFbEfC8AaAE ; < J31WMmF5Qsm7M6Hjr5qUiqGMmaqrO81I21u725BJOLPl05020IrW2RnEWp5WpYzR > >										5
90 //	        < 6 ; 11M ; DEC 2019 ; opt. ; - ; 0 ; 1,14479319034117 ; -1 ; -0,00025 ; 0,00025 ; -4,3 ; -7,9 ; 3 ; -1 ; 0,1 ; 6 ; -0,63 ; NABCHFDE1960 ; 0F6ca653C4CfaCbf59FaDaBEca066AA0AABFAa1DabcBf6C7adfC0DCE85aE0aF5 ; < lT9E8P5y0FerM8Bqs0TgzvbassoKKosmqsZDPZH2j8E08OvI2j3KJFTvqxqlqzKm > >										6
91 //	        < 7 ; 12M ; JAN 2020 ; opt. ; - ; 0 ; 1,14644120563189 ; -1 ; -0,00025 ; 0,00025 ; -1,6 ; -9,9 ; -5,6 ; -8,1 ; -8,4 ; -6,2 ; 0,37 ; NABCHFJA2077 ; 4bDeb6eDCd4cca7cB38fc8fF5F1ABc90Ed1D60e4cDf66ca4dB6A25Ac5DA6AAdD ; < V5149966D1F998KNVSa3m63GzQhPH0MwG9i33N1j6J4NK8uk7AE8Z4DQzkR3ZVZ8 > >										7
92 //	        < 8 ; 14M ; MAR 2020 ; opt. ; - ; 0 ; 1,14824338024487 ; -1 ; -0,00025 ; 0,00025 ; 6,7 ; -6 ; -7,7 ; -7,6 ; -2,8 ; -1,1 ; 0,03 ; NABCHFMA2099 ; 3CeaeEA6d0aA862EC9AD34ebCFcDbBECbEABFBadE983FEdCddEaADBd1B0ef312 ; < 32Pg2P27LN8QbDxxzO3958BKft5efCTGal7WF1sL103L8Q30X9bVI5vg06S11v5n > >										8
93 //	        < 9 ; 16M ; MAY 2020 ; opt. ; - ; 0 ; 1,15045766962635 ; -1 ; -0,00025 ; 0,00025 ; -8,7 ; 0,5 ; -3,5 ; 8,2 ; -4,2 ; 4,6 ; 0,82 ; NABCHFMA2098 ; cDdBd07ebbCBEFCCF258AADAbaC8E6d27C5cDA4ca1eb39b8fD2bba28DfeEfbbe ; < Kz2YWe4s3b0YGrea33nPmum0mD9u0L01R82HXxJG98bR0uU34A1xlHaAx7U6m17V > >										9
94 //	        < 10 ; 18M ; JUL 2020 ; opt. ; - ; 0 ; 1,15287006399967 ; -1 ; -0,00025 ; 0,00025 ; -0,3 ; 8,9 ; -9,8 ; 8,7 ; -9,5 ; -7,3 ; -0,14 ; NABCHFJU2099 ; Dd12ac8c52Dd087c0cd55cECBEFD5B916bd4AD7a2FEfa1CEA0Fce6aBe81A2fC1 ; < kM2EOxfPO3JT4H7uZ657721dG6Py386Kmh92BZu5Q712JG3SNArp8oVc36R0u5g0 > >										10
95 //	        < 11 ; 20M ; SEP 2020 ; opt. ; - ; 0 ; 1,15548296118516 ; -1 ; -0,00025 ; 0,00025 ; 2,9 ; 2,5 ; 0,5 ; 2,9 ; -8,5 ; -1 ; 0,9 ; NABCHFSE2027 ; d34aF6d403FE9bF0AFa6EbB3be0Fbcbc0f45e41a5aBf64Addc631eCcEdfDcFeC ; < CZjPtnbenu58McUhXw8wi3oh9Q934V132IV3ydsGDodqZ7X2gOHRIx6Vo0ttlCXA > >										11
96 //	        < 12 ; 23M ; DEC 2020 ; opt. ; - ; 0 ; 1,15846295174206 ; -1 ; -0,00025 ; 0,00025 ; -7,2 ; -8,4 ; -4,9 ; 0,8 ; -7,8 ; 7,8 ; 0,77 ; NABCHFDE2056 ; 5dCfBfE1ABDcc3eefDDF7DffeCeeec3F0BeEf815deEbBa4FAbC3126Bda4BF67a ; < GgPVOrC2U6H1lv5o112V46c75ycvgT6TPVg6Hq6r3t8HuGwi6435cO1d9B98AePv > >										12
97 //	        < 13 ; 24M ; JAN 2021 ; opt. ; - ; 0 ; 1,16149420355209 ; -1 ; -0,00025 ; 0,00025 ; -5,5 ; 9,7 ; 9,3 ; -6,5 ; 7,6 ; 0 ; -0,92 ; NABCHFJA2180 ; 5d8a9eAAf19Ccaf8A0E11Ceb4B3FFEcbD7Ff5dDa7521Db9f821E8CECcAf36430 ; < eQEm0ejeasWYcXX1wD6xK52EXY61eD0OWQIy4Ir8O1R1ts9r79mWeNrLF9a82uNe > >										13
98 //	        < 14 ; 26M ; MAR 2021 ; opt. ; - ; 0 ; 1,16477806578029 ; -1 ; -0,00025 ; 0,00025 ; -2,6 ; -4,3 ; 6,4 ; 6,3 ; 9,9 ; -5,5 ; -0,35 ; NABCHFMA2159 ; A2Af98F1d8dC19DFaefF71AD1cD4Cd07ba3642BbdEDF44ceAcdD9E3DF575DED4 ; < hd5Fu8gTt7QH50zOsmBDlJSKD28cq3XFyCv56Iuw1kR1JD6My8mNVKn0T57EtRB8 > >										14
99 //	        < 15 ; 28M ; MAY 2021 ; opt. ; - ; 0 ; 1,16836089510099 ; -1 ; -0,00025 ; 0,00025 ; 5,1 ; -0,1 ; 6,2 ; -5,2 ; -6,5 ; 0,4 ; -0,23 ; NABCHFMA2124 ; cDABAE2e1a3162465267EeB9d0AcB53FFD95dDEB72d841a9d6A9a8Ea4391aCFE ; < e2G46C2DH1se80c7378ebrk7Qp987qikfs15kB08HdD172Er28B2bYC9a25zty89 > >										15
100 //	        < 16 ; 30M ; JUL 2021 ; opt. ; - ; 0 ; 1,1723014509549 ; -1 ; -0,00025 ; 0,00025 ; 5,6 ; -1,7 ; 0,2 ; 6,8 ; 5,3 ; -8,1 ; -0,1 ; NABCHFJU2171 ; 01F0e9d1E2C2EeF2FbD35f0b1dcDdAFDAE3Df7DF5Cc609AA402D3c0db9f7b937 ; < bLt7wJY87zBEpGxwA9y5reIGGDi5cBGy8OdeXYJ5k6wBoELWaNJ04q3lZg6Q2cNF > >										16
101 //	        < 17 ; 32M ; SEP 2021 ; opt. ; - ; 0 ; 1,17637345222373 ; -1 ; -0,00025 ; 0,00025 ; -2,2 ; 4,1 ; -6,8 ; 2,7 ; 6 ; 7,3 ; 0,03 ; NABCHFSE2171 ; C6faBfC0B002cE02a9db6FCEEbac204F9E1e3AD47e8e47eef5B2ddedcD6Cc6ea ; < XXfLDU2fM2iY8PPKg4n6fu7hTC07R0IedjydF0vf25gZNC3ljGQLO3cX9JTvp7Ii > >										17
102 //	        < 18 ; 35M ; DEC 2021 ; opt. ; - ; 0 ; 1,18067702954261 ; -1 ; -0,00025 ; 0,00025 ; -7,3 ; 9,1 ; 0,8 ; 6,7 ; -2 ; 2,2 ; 0,6 ; NABCHFDE2113 ; AD5bfdbf7ECBF1fEa63E4Ee0fFAEAD0dE8aE69e3401809F6DcF4DdBcF4bCF3FA ; < 7L8oAqY376Xn2xSoxRYLGD5LN0tQZ45E9NTmT7E7mOMlh6ecjEqkLngqKigur25A > >										18
103 //	        < 19 ; 36M ; JAN 2021 ; opt. ; - ; 0 ; 1,18526067588708 ; -1 ; -0,00025 ; 0,00025 ; 5,7 ; 1,1 ; 3,4 ; -8 ; 4,8 ; 6,3 ; -0,72 ; NABCHFJA2141 ; dACeBdB2ffBecDffdC6AEc8aa2aaA7443ab94cEf6Bbb4Fd56bBDbde5DA8EcAbf ; < 11rvxSPZGo60UkKY1vxRRwmHD8wXA7iuTk5aB40XNq3t2dxRr13l8Iw5eImRjR75 > >										19
104 //	        < 20 ; 38M ; MAR 2021 ; opt. ; - ; 0 ; 1,1902934561942 ; -1 ; -0,00025 ; 0,00025 ; 7,9 ; 8 ; -7,8 ; -8,5 ; -3,1 ; -2,1 ; -0,39 ; NABCHFMA2182 ; dd55DCeB2EA6cffA85EBE7babe0eeabefA5B3FFE4fffC0CEcc36ECCcdC04Db8f ; < l8bH67KcPcaj8y9yFVg9WnfS5HKz4Tq05o8LBB99ic3xMdI2z57Ab813KjoGw1yn > >										20
105 //	        < 21 ; 40M ; MAY 2021 ; opt. ; - ; 0 ; 1,19549991964447 ; -1 ; -0,00025 ; 0,00025 ; 4 ; -3,9 ; 7,4 ; 8,3 ; 7,6 ; 5,3 ; -0,04 ; NABCHFMA2157 ; CFB1A6C4Ca0bA4CCFC25DEcffD7e1Adc275bbADb7A6b2e8fbdfeFcF92c4E0fC8 ; < vbr3PF1T95KfJ25zhXcRJVH0RvZ99U0f3CH67PO3y1XRF48ag9P6959a3rOJC40o > >										21
106 //	        < 22 ; 42M ; JUL 2021 ; opt. ; - ; 0 ; 1,20095391816801 ; -1 ; -0,00025 ; 0,00025 ; -3,9 ; 6,7 ; 6 ; 9,2 ; 8,1 ; 5 ; 0,69 ; NABCHFJU2192 ; Ac72206F728fE1dBcE7eC0CbdFeded8dB78eacABd4fda8DceCcE49EE56DbBDb0 ; < gS0q373tlGLVP1887PTP31Ns9vAk2Np9120eJDCI8ZuM7jYXxMilGzB5jeGw7Fth > >										22
107 //	        < 23 ; 44M ; SEP 2021 ; opt. ; - ; 0 ; 1,2066814556377 ; -1 ; -0,00025 ; 0,00025 ; -7,4 ; 9 ; 8,9 ; -1,2 ; 0,4 ; -1,4 ; -0,11 ; NABCHFSE2185 ; 2E42cD2fE5bBe4fEF6E6bD1c9D8b91AE4B1ec4fDfaFcAba0FfC8CCFeB9c1aecA ; < 5eTK7c6z2SXEavxk8vB09vnEb94Ny89oVr97H0w6QV729bBE87T11F2J1N468G9V > >										23
108 //	        < 24 ; 47M ; DEC 2021 ; opt. ; - ; 0 ; 1,21261742338835 ; -1 ; -0,00025 ; 0,00025 ; 5,3 ; -3,7 ; 9,7 ; -2,1 ; -7,1 ; -3 ; 0,55 ; NABCHFDE2120 ; C2CDEFEAfC5fdC8Dfea8ECFe2bccad7c6E3DDADffaeB529Ce75CBA28A9eD9ccd ; < CBYLN2RPT20f9onrtqx7KYhr06yP7Lf4k15KqwPp58knhKon8339n86L3A3Mh49X > >										24
109 											
110 //	  < CALLS ; 3M ; Strike ; Symbol ; Last ; T(-1) ; Change ; Volume ; BAS_1 ; BAS_2 ; o.i. @ eth_hex ; @ btc_882 >										
111 											
112 //	#DIV/0 !										1
113 //	#DIV/0 !										2
114 //	#DIV/0 !										3
115 //	#DIV/0 !										4
116 //	#DIV/0 !										5
117 //	#DIV/0 !										6
118 //	#DIV/0 !										7
119 //	#DIV/0 !										8
120 //	#DIV/0 !										9
121 //	#DIV/0 !										10
122 //	#DIV/0 !										11
123 //	#DIV/0 !										12
124 //	#DIV/0 !										13
125 //	#DIV/0 !										14
126 //	#DIV/0 !										15
127 //	#DIV/0 !										16
128 //	#DIV/0 !										17
129 //	#DIV/0 !										18
130 //	#DIV/0 !										19
131 //	#DIV/0 !										20
132 //	#DIV/0 !										21
133 //											
134 //	  < PUTS ; 3M ; Strike ; Symbol ; Last ; T(-1) ; Change ; Volume ; BAS_1 ; BAS_2 ; o.i. @ eth_hex ; @ btc_882 >										
135 //											
136 //	#DIV/0 !										1
137 //	#DIV/0 !										2
138 //	#DIV/0 !										3
139 //	#DIV/0 !										4
140 //	#DIV/0 !										5
141 //	#DIV/0 !										6
142 //	#DIV/0 !										7
143 //	#DIV/0 !										8
144 //	#DIV/0 !										9
145 //	#DIV/0 !										10
146 //	#DIV/0 !										11
147 //	#DIV/0 !										12
148 //	#DIV/0 !										13
149 //	#DIV/0 !										14
150 //	#DIV/0 !										15
151 //	#DIV/0 !										16
152 //	#DIV/0 !										17
153 //	#DIV/0 !										18
154 //	#DIV/0 !										19
155 //	#DIV/0 !										20
156 //	#DIV/0 !										21
157 											
158 											
159 											
160 											
161 											
162 //	NABCHF										
163 											
164 //	  < # ; REF ; Month ; Optionchain ; Chart ; Last ; T(-1) ; Change ; BAS_1 ; BAS_2 ; Prior. Settle ; Open ; High ; Low ; Volume ; Hi / Lo ; Updated (s) ; Code ; @ eth_hex ; @ btc_882 >										
165 											
166 //	        < 0 ; T0 ; - ; - ; - ; 0 ; 1,14 ; -1 ; - ; - ; - ; - ; - ; - ; - ; - ; - ; - ; FD28Bf2C6FFDcfdD1A8BC7CcAaAbd5Ac7a87d4CebDadbC9abB2dEbdcAE79F784 ; < k2SR6nfbN2EJ6b2AMWmk65z9T6IqW0Op4GunR162OoXfxchdC4T48T3tG6791U8t > >										0
167 //	        < 1 ; 0M ; JAN 2019 ; opt. ; - ; 0 ; 1,14022012829845 ; -1 ; -0,00025 ; 0,00025 ; 5,5 ; -8,3 ; 9,1 ; -7,1 ; 4,8 ; -1,1 ; 0,59 ; NABCHF93JA19 ; 4baCAA8CFF9BDadE35feA82cC35DaCCA933cFbACacA6dEfE5cE67C9EDAFEeeee ; < B3Os41Ck3UlIYn6efoHq8G439a27R3vltA2LwSDk8gu5q99L42kNicW3OR09k4rR > >										1
168 //	        < 2 ; 2M ; MAR 2019 ; opt. ; - ; 0 ; 1,14079278481714 ; -1 ; -0,00025 ; 0,00025 ; -4,3 ; 0,4 ; 1,5 ; 6,9 ; -2,1 ; -2,7 ; -0,15 ; NABCHFMA1971 ; 7B7DA8CefD8fDfc4cA3f3F04Dfb8C110Af2DFF0D53Ca2d676E638dEe4ED70DD2 ; < 4438Dh6rRPL218n73F05GcN4X626kuVFWqLH3GY0C64RkNeebumBH0sHHbXGz8o2 > >										2
169 //	        < 3 ; 4M ; MAY 2019 ; opt. ; - ; 0 ; 1,14142639814536 ; -1 ; -0,00025 ; 0,00025 ; -6,5 ; 2 ; 2,1 ; -2,3 ; -3,9 ; 4,1 ; 0,1 ; NABCHFMA1948 ; df9fcacB6c9E34Eb7DffC5Aba03a0d0bAceAffe866e7eF1fAb35e6eb811f8ce2 ; < EeuSGuN854799iqt5O4rP19N6nHrlte57b6vPWQTDQuinp9Flq9ersdZX27ikF9t > >										3
170 //	        < 4 ; 6M ; JUL 2019 ; opt. ; - ; 0 ; 1,14237451239954 ; -1 ; -0,00025 ; 0,00025 ; -5 ; -4,9 ; 1,4 ; -1,8 ; -0,8 ; 3,2 ; -0,87 ; NABCHFJU1924 ; 67EBD1Ea5CeC54c7b3daBC0c0f98630653C14faeAdDD1baF7DCEc49aD8bacea4 ; < hX151v3CmklD8T45e1PVeaA84qBqs8GWnva2gfnzZ23O394m1dU1bqTdhf1UI9uc > >										4
171 //	        < 5 ; 8M ; SEP 2019 ; opt. ; - ; 0 ; 1,14346880221948 ; -1 ; -0,00025 ; 0,00025 ; -8,2 ; 1,5 ; -3,7 ; -4,9 ; 4,5 ; 3,3 ; -0,73 ; NABCHFSE1987 ; BEDb9ACaf62f7821BDA4b438Df40Bfa3AE7d8acD2FCC6debfccC6aFbEfC8AaAE ; < J31WMmF5Qsm7M6Hjr5qUiqGMmaqrO81I21u725BJOLPl05020IrW2RnEWp5WpYzR > >										5
172 //	        < 6 ; 11M ; DEC 2019 ; opt. ; - ; 0 ; 1,14479319034117 ; -1 ; -0,00025 ; 0,00025 ; -4,3 ; -7,9 ; 3 ; -1 ; 0,1 ; 6 ; -0,63 ; NABCHFDE1960 ; 0F6ca653C4CfaCbf59FaDaBEca066AA0AABFAa1DabcBf6C7adfC0DCE85aE0aF5 ; < lT9E8P5y0FerM8Bqs0TgzvbassoKKosmqsZDPZH2j8E08OvI2j3KJFTvqxqlqzKm > >										6
173 //	        < 7 ; 12M ; JAN 2020 ; opt. ; - ; 0 ; 1,14644120563189 ; -1 ; -0,00025 ; 0,00025 ; -1,6 ; -9,9 ; -5,6 ; -8,1 ; -8,4 ; -6,2 ; 0,37 ; NABCHFJA2077 ; 4bDeb6eDCd4cca7cB38fc8fF5F1ABc90Ed1D60e4cDf66ca4dB6A25Ac5DA6AAdD ; < V5149966D1F998KNVSa3m63GzQhPH0MwG9i33N1j6J4NK8uk7AE8Z4DQzkR3ZVZ8 > >										7
174 //	        < 8 ; 14M ; MAR 2020 ; opt. ; - ; 0 ; 1,14824338024487 ; -1 ; -0,00025 ; 0,00025 ; 6,7 ; -6 ; -7,7 ; -7,6 ; -2,8 ; -1,1 ; 0,03 ; NABCHFMA2099 ; 3CeaeEA6d0aA862EC9AD34ebCFcDbBECbEABFBadE983FEdCddEaADBd1B0ef312 ; < 32Pg2P27LN8QbDxxzO3958BKft5efCTGal7WF1sL103L8Q30X9bVI5vg06S11v5n > >										8
175 //	        < 9 ; 16M ; MAY 2020 ; opt. ; - ; 0 ; 1,15045766962635 ; -1 ; -0,00025 ; 0,00025 ; -8,7 ; 0,5 ; -3,5 ; 8,2 ; -4,2 ; 4,6 ; 0,82 ; NABCHFMA2098 ; cDdBd07ebbCBEFCCF258AADAbaC8E6d27C5cDA4ca1eb39b8fD2bba28DfeEfbbe ; < Kz2YWe4s3b0YGrea33nPmum0mD9u0L01R82HXxJG98bR0uU34A1xlHaAx7U6m17V > >										9
176 //	        < 10 ; 18M ; JUL 2020 ; opt. ; - ; 0 ; 1,15287006399967 ; -1 ; -0,00025 ; 0,00025 ; -0,3 ; 8,9 ; -9,8 ; 8,7 ; -9,5 ; -7,3 ; -0,14 ; NABCHFJU2099 ; Dd12ac8c52Dd087c0cd55cECBEFD5B916bd4AD7a2FEfa1CEA0Fce6aBe81A2fC1 ; < kM2EOxfPO3JT4H7uZ657721dG6Py386Kmh92BZu5Q712JG3SNArp8oVc36R0u5g0 > >										10
177 //	        < 11 ; 20M ; SEP 2020 ; opt. ; - ; 0 ; 1,15548296118516 ; -1 ; -0,00025 ; 0,00025 ; 2,9 ; 2,5 ; 0,5 ; 2,9 ; -8,5 ; -1 ; 0,9 ; NABCHFSE2027 ; d34aF6d403FE9bF0AFa6EbB3be0Fbcbc0f45e41a5aBf64Addc631eCcEdfDcFeC ; < CZjPtnbenu58McUhXw8wi3oh9Q934V132IV3ydsGDodqZ7X2gOHRIx6Vo0ttlCXA > >										11
178 //	        < 12 ; 23M ; DEC 2020 ; opt. ; - ; 0 ; 1,15846295174206 ; -1 ; -0,00025 ; 0,00025 ; -7,2 ; -8,4 ; -4,9 ; 0,8 ; -7,8 ; 7,8 ; 0,77 ; NABCHFDE2056 ; 5dCfBfE1ABDcc3eefDDF7DffeCeeec3F0BeEf815deEbBa4FAbC3126Bda4BF67a ; < GgPVOrC2U6H1lv5o112V46c75ycvgT6TPVg6Hq6r3t8HuGwi6435cO1d9B98AePv > >										12
179 //	        < 13 ; 24M ; JAN 2021 ; opt. ; - ; 0 ; 1,16149420355209 ; -1 ; -0,00025 ; 0,00025 ; -5,5 ; 9,7 ; 9,3 ; -6,5 ; 7,6 ; 0 ; -0,92 ; NABCHFJA2180 ; 5d8a9eAAf19Ccaf8A0E11Ceb4B3FFEcbD7Ff5dDa7521Db9f821E8CECcAf36430 ; < eQEm0ejeasWYcXX1wD6xK52EXY61eD0OWQIy4Ir8O1R1ts9r79mWeNrLF9a82uNe > >										13
180 //	        < 14 ; 26M ; MAR 2021 ; opt. ; - ; 0 ; 1,16477806578029 ; -1 ; -0,00025 ; 0,00025 ; -2,6 ; -4,3 ; 6,4 ; 6,3 ; 9,9 ; -5,5 ; -0,35 ; NABCHFMA2159 ; A2Af98F1d8dC19DFaefF71AD1cD4Cd07ba3642BbdEDF44ceAcdD9E3DF575DED4 ; < hd5Fu8gTt7QH50zOsmBDlJSKD28cq3XFyCv56Iuw1kR1JD6My8mNVKn0T57EtRB8 > >										14
181 //	        < 15 ; 28M ; MAY 2021 ; opt. ; - ; 0 ; 1,16836089510099 ; -1 ; -0,00025 ; 0,00025 ; 5,1 ; -0,1 ; 6,2 ; -5,2 ; -6,5 ; 0,4 ; -0,23 ; NABCHFMA2124 ; cDABAE2e1a3162465267EeB9d0AcB53FFD95dDEB72d841a9d6A9a8Ea4391aCFE ; < e2G46C2DH1se80c7378ebrk7Qp987qikfs15kB08HdD172Er28B2bYC9a25zty89 > >										15
182 //	        < 16 ; 30M ; JUL 2021 ; opt. ; - ; 0 ; 1,1723014509549 ; -1 ; -0,00025 ; 0,00025 ; 5,6 ; -1,7 ; 0,2 ; 6,8 ; 5,3 ; -8,1 ; -0,1 ; NABCHFJU2171 ; 01F0e9d1E2C2EeF2FbD35f0b1dcDdAFDAE3Df7DF5Cc609AA402D3c0db9f7b937 ; < bLt7wJY87zBEpGxwA9y5reIGGDi5cBGy8OdeXYJ5k6wBoELWaNJ04q3lZg6Q2cNF > >										16
183 //	        < 17 ; 32M ; SEP 2021 ; opt. ; - ; 0 ; 1,17637345222373 ; -1 ; -0,00025 ; 0,00025 ; -2,2 ; 4,1 ; -6,8 ; 2,7 ; 6 ; 7,3 ; 0,03 ; NABCHFSE2171 ; C6faBfC0B002cE02a9db6FCEEbac204F9E1e3AD47e8e47eef5B2ddedcD6Cc6ea ; < XXfLDU2fM2iY8PPKg4n6fu7hTC07R0IedjydF0vf25gZNC3ljGQLO3cX9JTvp7Ii > >										17
184 //	        < 18 ; 35M ; DEC 2021 ; opt. ; - ; 0 ; 1,18067702954261 ; -1 ; -0,00025 ; 0,00025 ; -7,3 ; 9,1 ; 0,8 ; 6,7 ; -2 ; 2,2 ; 0,6 ; NABCHFDE2113 ; AD5bfdbf7ECBF1fEa63E4Ee0fFAEAD0dE8aE69e3401809F6DcF4DdBcF4bCF3FA ; < 7L8oAqY376Xn2xSoxRYLGD5LN0tQZ45E9NTmT7E7mOMlh6ecjEqkLngqKigur25A > >										18
185 //	        < 19 ; 36M ; JAN 2021 ; opt. ; - ; 0 ; 1,18526067588708 ; -1 ; -0,00025 ; 0,00025 ; 5,7 ; 1,1 ; 3,4 ; -8 ; 4,8 ; 6,3 ; -0,72 ; NABCHFJA2141 ; dACeBdB2ffBecDffdC6AEc8aa2aaA7443ab94cEf6Bbb4Fd56bBDbde5DA8EcAbf ; < 11rvxSPZGo60UkKY1vxRRwmHD8wXA7iuTk5aB40XNq3t2dxRr13l8Iw5eImRjR75 > >										19
186 //	        < 20 ; 38M ; MAR 2021 ; opt. ; - ; 0 ; 1,1902934561942 ; -1 ; -0,00025 ; 0,00025 ; 7,9 ; 8 ; -7,8 ; -8,5 ; -3,1 ; -2,1 ; -0,39 ; NABCHFMA2182 ; dd55DCeB2EA6cffA85EBE7babe0eeabefA5B3FFE4fffC0CEcc36ECCcdC04Db8f ; < l8bH67KcPcaj8y9yFVg9WnfS5HKz4Tq05o8LBB99ic3xMdI2z57Ab813KjoGw1yn > >										20
187 //	        < 21 ; 40M ; MAY 2021 ; opt. ; - ; 0 ; 1,19549991964447 ; -1 ; -0,00025 ; 0,00025 ; 4 ; -3,9 ; 7,4 ; 8,3 ; 7,6 ; 5,3 ; -0,04 ; NABCHFMA2157 ; CFB1A6C4Ca0bA4CCFC25DEcffD7e1Adc275bbADb7A6b2e8fbdfeFcF92c4E0fC8 ; < vbr3PF1T95KfJ25zhXcRJVH0RvZ99U0f3CH67PO3y1XRF48ag9P6959a3rOJC40o > >										21
188 //	        < 22 ; 42M ; JUL 2021 ; opt. ; - ; 0 ; 1,20095391816801 ; -1 ; -0,00025 ; 0,00025 ; -3,9 ; 6,7 ; 6 ; 9,2 ; 8,1 ; 5 ; 0,69 ; NABCHFJU2192 ; Ac72206F728fE1dBcE7eC0CbdFeded8dB78eacABd4fda8DceCcE49EE56DbBDb0 ; < gS0q373tlGLVP1887PTP31Ns9vAk2Np9120eJDCI8ZuM7jYXxMilGzB5jeGw7Fth > >										22
189 //	        < 23 ; 44M ; SEP 2021 ; opt. ; - ; 0 ; 1,2066814556377 ; -1 ; -0,00025 ; 0,00025 ; -7,4 ; 9 ; 8,9 ; -1,2 ; 0,4 ; -1,4 ; -0,11 ; NABCHFSE2185 ; 2E42cD2fE5bBe4fEF6E6bD1c9D8b91AE4B1ec4fDfaFcAba0FfC8CCFeB9c1aecA ; < 5eTK7c6z2SXEavxk8vB09vnEb94Ny89oVr97H0w6QV729bBE87T11F2J1N468G9V > >										23
190 //	        < 24 ; 47M ; DEC 2021 ; opt. ; - ; 0 ; 1,21261742338835 ; -1 ; -0,00025 ; 0,00025 ; 5,3 ; -3,7 ; 9,7 ; -2,1 ; -7,1 ; -3 ; 0,55 ; NABCHFDE2120 ; C2CDEFEAfC5fdC8Dfea8ECFe2bccad7c6E3DDADffaeB529Ce75CBA28A9eD9ccd ; < CBYLN2RPT20f9onrtqx7KYhr06yP7Lf4k15KqwPp58knhKon8339n86L3A3Mh49X > >										24
191 											
192 //	  < CALLS ; 6M ; Strike ; Symbol ; Last ; T(-1) ; Change ; Volume ; BAS_1 ; BAS_2 ; o.i. @ eth_hex ; @ btc_882 >										
193 											
194 //	#DIV/0 !										1
195 //	#DIV/0 !										2
196 //	#DIV/0 !										3
197 //	#DIV/0 !										4
198 //	#DIV/0 !										5
199 //	#DIV/0 !										6
200 //	#DIV/0 !										7
201 //	#DIV/0 !										8
202 //	#DIV/0 !										9
203 //	#DIV/0 !										10
204 //	#DIV/0 !										11
205 //	#DIV/0 !										12
206 //	#DIV/0 !										13
207 //	#DIV/0 !										14
208 //	#DIV/0 !										15
209 //	#DIV/0 !										16
210 //	#DIV/0 !										17
211 //	#DIV/0 !										18
212 //	#DIV/0 !										19
213 //	#DIV/0 !										20
214 //	#DIV/0 !										21
215 //											
216 //	  < PUTS ; 6M ; Strike ; Symbol ; Last ; T(-1) ; Change ; Volume ; BAS_1 ; BAS_2 ; o.i. @ eth_hex ; @ btc_882 >										
217 //											
218 //	#DIV/0 !										1
219 //	#DIV/0 !										2
220 //	#DIV/0 !										3
221 //	#DIV/0 !										4
222 //	#DIV/0 !										5
223 //	#DIV/0 !										6
224 //	#DIV/0 !										7
225 //	#DIV/0 !										8
226 //	#DIV/0 !										9
227 //	#DIV/0 !										10
228 //	#DIV/0 !										11
229 //	#DIV/0 !										12
230 //	#DIV/0 !										13
231 //	#DIV/0 !										14
232 //	#DIV/0 !										15
233 //	#DIV/0 !										16
234 //	#DIV/0 !										17
235 //	#DIV/0 !										18
236 //	#DIV/0 !										19
237 //	#DIV/0 !										20
238 //	#DIV/0 !										21
239 											
240 											
241 											
242 											
243 											
244 //	NABCHF										
245 											
246 //	  < # ; REF ; Month ; Optionchain ; Chart ; Last ; T(-1) ; Change ; BAS_1 ; BAS_2 ; Prior. Settle ; Open ; High ; Low ; Volume ; Hi / Lo ; Updated (s) ; Code ; @ eth_hex ; @ btc_882 >										
247 											
248 //	        < 0 ; T0 ; - ; - ; - ; 0 ; 1,14 ; -1 ; - ; - ; - ; - ; - ; - ; - ; - ; - ; - ; FD28Bf2C6FFDcfdD1A8BC7CcAaAbd5Ac7a87d4CebDadbC9abB2dEbdcAE79F784 ; < k2SR6nfbN2EJ6b2AMWmk65z9T6IqW0Op4GunR162OoXfxchdC4T48T3tG6791U8t > >										0
249 //	        < 1 ; 0M ; JAN 2019 ; opt. ; - ; 0 ; 1,14022012829845 ; -1 ; -0,00025 ; 0,00025 ; 5,5 ; -8,3 ; 9,1 ; -7,1 ; 4,8 ; -1,1 ; 0,59 ; NABCHF93JA19 ; 4baCAA8CFF9BDadE35feA82cC35DaCCA933cFbACacA6dEfE5cE67C9EDAFEeeee ; < B3Os41Ck3UlIYn6efoHq8G439a27R3vltA2LwSDk8gu5q99L42kNicW3OR09k4rR > >										1
250 //	        < 2 ; 2M ; MAR 2019 ; opt. ; - ; 0 ; 1,14079278481714 ; -1 ; -0,00025 ; 0,00025 ; -4,3 ; 0,4 ; 1,5 ; 6,9 ; -2,1 ; -2,7 ; -0,15 ; NABCHFMA1971 ; 7B7DA8CefD8fDfc4cA3f3F04Dfb8C110Af2DFF0D53Ca2d676E638dEe4ED70DD2 ; < 4438Dh6rRPL218n73F05GcN4X626kuVFWqLH3GY0C64RkNeebumBH0sHHbXGz8o2 > >										2
251 //	        < 3 ; 4M ; MAY 2019 ; opt. ; - ; 0 ; 1,14142639814536 ; -1 ; -0,00025 ; 0,00025 ; -6,5 ; 2 ; 2,1 ; -2,3 ; -3,9 ; 4,1 ; 0,1 ; NABCHFMA1948 ; df9fcacB6c9E34Eb7DffC5Aba03a0d0bAceAffe866e7eF1fAb35e6eb811f8ce2 ; < EeuSGuN854799iqt5O4rP19N6nHrlte57b6vPWQTDQuinp9Flq9ersdZX27ikF9t > >										3
252 //	        < 4 ; 6M ; JUL 2019 ; opt. ; - ; 0 ; 1,14237451239954 ; -1 ; -0,00025 ; 0,00025 ; -5 ; -4,9 ; 1,4 ; -1,8 ; -0,8 ; 3,2 ; -0,87 ; NABCHFJU1924 ; 67EBD1Ea5CeC54c7b3daBC0c0f98630653C14faeAdDD1baF7DCEc49aD8bacea4 ; < hX151v3CmklD8T45e1PVeaA84qBqs8GWnva2gfnzZ23O394m1dU1bqTdhf1UI9uc > >										4
253 //	        < 5 ; 8M ; SEP 2019 ; opt. ; - ; 0 ; 1,14346880221948 ; -1 ; -0,00025 ; 0,00025 ; -8,2 ; 1,5 ; -3,7 ; -4,9 ; 4,5 ; 3,3 ; -0,73 ; NABCHFSE1987 ; BEDb9ACaf62f7821BDA4b438Df40Bfa3AE7d8acD2FCC6debfccC6aFbEfC8AaAE ; < J31WMmF5Qsm7M6Hjr5qUiqGMmaqrO81I21u725BJOLPl05020IrW2RnEWp5WpYzR > >										5
254 //	        < 6 ; 11M ; DEC 2019 ; opt. ; - ; 0 ; 1,14479319034117 ; -1 ; -0,00025 ; 0,00025 ; -4,3 ; -7,9 ; 3 ; -1 ; 0,1 ; 6 ; -0,63 ; NABCHFDE1960 ; 0F6ca653C4CfaCbf59FaDaBEca066AA0AABFAa1DabcBf6C7adfC0DCE85aE0aF5 ; < lT9E8P5y0FerM8Bqs0TgzvbassoKKosmqsZDPZH2j8E08OvI2j3KJFTvqxqlqzKm > >										6
255 //	        < 7 ; 12M ; JAN 2020 ; opt. ; - ; 0 ; 1,14644120563189 ; -1 ; -0,00025 ; 0,00025 ; -1,6 ; -9,9 ; -5,6 ; -8,1 ; -8,4 ; -6,2 ; 0,37 ; NABCHFJA2077 ; 4bDeb6eDCd4cca7cB38fc8fF5F1ABc90Ed1D60e4cDf66ca4dB6A25Ac5DA6AAdD ; < V5149966D1F998KNVSa3m63GzQhPH0MwG9i33N1j6J4NK8uk7AE8Z4DQzkR3ZVZ8 > >										7
256 //	        < 8 ; 14M ; MAR 2020 ; opt. ; - ; 0 ; 1,14824338024487 ; -1 ; -0,00025 ; 0,00025 ; 6,7 ; -6 ; -7,7 ; -7,6 ; -2,8 ; -1,1 ; 0,03 ; NABCHFMA2099 ; 3CeaeEA6d0aA862EC9AD34ebCFcDbBECbEABFBadE983FEdCddEaADBd1B0ef312 ; < 32Pg2P27LN8QbDxxzO3958BKft5efCTGal7WF1sL103L8Q30X9bVI5vg06S11v5n > >										8
257 //	        < 9 ; 16M ; MAY 2020 ; opt. ; - ; 0 ; 1,15045766962635 ; -1 ; -0,00025 ; 0,00025 ; -8,7 ; 0,5 ; -3,5 ; 8,2 ; -4,2 ; 4,6 ; 0,82 ; NABCHFMA2098 ; cDdBd07ebbCBEFCCF258AADAbaC8E6d27C5cDA4ca1eb39b8fD2bba28DfeEfbbe ; < Kz2YWe4s3b0YGrea33nPmum0mD9u0L01R82HXxJG98bR0uU34A1xlHaAx7U6m17V > >										9
258 //	        < 10 ; 18M ; JUL 2020 ; opt. ; - ; 0 ; 1,15287006399967 ; -1 ; -0,00025 ; 0,00025 ; -0,3 ; 8,9 ; -9,8 ; 8,7 ; -9,5 ; -7,3 ; -0,14 ; NABCHFJU2099 ; Dd12ac8c52Dd087c0cd55cECBEFD5B916bd4AD7a2FEfa1CEA0Fce6aBe81A2fC1 ; < kM2EOxfPO3JT4H7uZ657721dG6Py386Kmh92BZu5Q712JG3SNArp8oVc36R0u5g0 > >										10
259 //	        < 11 ; 20M ; SEP 2020 ; opt. ; - ; 0 ; 1,15548296118516 ; -1 ; -0,00025 ; 0,00025 ; 2,9 ; 2,5 ; 0,5 ; 2,9 ; -8,5 ; -1 ; 0,9 ; NABCHFSE2027 ; d34aF6d403FE9bF0AFa6EbB3be0Fbcbc0f45e41a5aBf64Addc631eCcEdfDcFeC ; < CZjPtnbenu58McUhXw8wi3oh9Q934V132IV3ydsGDodqZ7X2gOHRIx6Vo0ttlCXA > >										11
260 //	        < 12 ; 23M ; DEC 2020 ; opt. ; - ; 0 ; 1,15846295174206 ; -1 ; -0,00025 ; 0,00025 ; -7,2 ; -8,4 ; -4,9 ; 0,8 ; -7,8 ; 7,8 ; 0,77 ; NABCHFDE2056 ; 5dCfBfE1ABDcc3eefDDF7DffeCeeec3F0BeEf815deEbBa4FAbC3126Bda4BF67a ; < GgPVOrC2U6H1lv5o112V46c75ycvgT6TPVg6Hq6r3t8HuGwi6435cO1d9B98AePv > >										12
261 //	        < 13 ; 24M ; JAN 2021 ; opt. ; - ; 0 ; 1,16149420355209 ; -1 ; -0,00025 ; 0,00025 ; -5,5 ; 9,7 ; 9,3 ; -6,5 ; 7,6 ; 0 ; -0,92 ; NABCHFJA2180 ; 5d8a9eAAf19Ccaf8A0E11Ceb4B3FFEcbD7Ff5dDa7521Db9f821E8CECcAf36430 ; < eQEm0ejeasWYcXX1wD6xK52EXY61eD0OWQIy4Ir8O1R1ts9r79mWeNrLF9a82uNe > >										13
262 //	        < 14 ; 26M ; MAR 2021 ; opt. ; - ; 0 ; 1,16477806578029 ; -1 ; -0,00025 ; 0,00025 ; -2,6 ; -4,3 ; 6,4 ; 6,3 ; 9,9 ; -5,5 ; -0,35 ; NABCHFMA2159 ; A2Af98F1d8dC19DFaefF71AD1cD4Cd07ba3642BbdEDF44ceAcdD9E3DF575DED4 ; < hd5Fu8gTt7QH50zOsmBDlJSKD28cq3XFyCv56Iuw1kR1JD6My8mNVKn0T57EtRB8 > >										14
263 //	        < 15 ; 28M ; MAY 2021 ; opt. ; - ; 0 ; 1,16836089510099 ; -1 ; -0,00025 ; 0,00025 ; 5,1 ; -0,1 ; 6,2 ; -5,2 ; -6,5 ; 0,4 ; -0,23 ; NABCHFMA2124 ; cDABAE2e1a3162465267EeB9d0AcB53FFD95dDEB72d841a9d6A9a8Ea4391aCFE ; < e2G46C2DH1se80c7378ebrk7Qp987qikfs15kB08HdD172Er28B2bYC9a25zty89 > >										15
264 //	        < 16 ; 30M ; JUL 2021 ; opt. ; - ; 0 ; 1,1723014509549 ; -1 ; -0,00025 ; 0,00025 ; 5,6 ; -1,7 ; 0,2 ; 6,8 ; 5,3 ; -8,1 ; -0,1 ; NABCHFJU2171 ; 01F0e9d1E2C2EeF2FbD35f0b1dcDdAFDAE3Df7DF5Cc609AA402D3c0db9f7b937 ; < bLt7wJY87zBEpGxwA9y5reIGGDi5cBGy8OdeXYJ5k6wBoELWaNJ04q3lZg6Q2cNF > >										16
265 //	        < 17 ; 32M ; SEP 2021 ; opt. ; - ; 0 ; 1,17637345222373 ; -1 ; -0,00025 ; 0,00025 ; -2,2 ; 4,1 ; -6,8 ; 2,7 ; 6 ; 7,3 ; 0,03 ; NABCHFSE2171 ; C6faBfC0B002cE02a9db6FCEEbac204F9E1e3AD47e8e47eef5B2ddedcD6Cc6ea ; < XXfLDU2fM2iY8PPKg4n6fu7hTC07R0IedjydF0vf25gZNC3ljGQLO3cX9JTvp7Ii > >										17
266 //	        < 18 ; 35M ; DEC 2021 ; opt. ; - ; 0 ; 1,18067702954261 ; -1 ; -0,00025 ; 0,00025 ; -7,3 ; 9,1 ; 0,8 ; 6,7 ; -2 ; 2,2 ; 0,6 ; NABCHFDE2113 ; AD5bfdbf7ECBF1fEa63E4Ee0fFAEAD0dE8aE69e3401809F6DcF4DdBcF4bCF3FA ; < 7L8oAqY376Xn2xSoxRYLGD5LN0tQZ45E9NTmT7E7mOMlh6ecjEqkLngqKigur25A > >										18
267 //	        < 19 ; 36M ; JAN 2021 ; opt. ; - ; 0 ; 1,18526067588708 ; -1 ; -0,00025 ; 0,00025 ; 5,7 ; 1,1 ; 3,4 ; -8 ; 4,8 ; 6,3 ; -0,72 ; NABCHFJA2141 ; dACeBdB2ffBecDffdC6AEc8aa2aaA7443ab94cEf6Bbb4Fd56bBDbde5DA8EcAbf ; < 11rvxSPZGo60UkKY1vxRRwmHD8wXA7iuTk5aB40XNq3t2dxRr13l8Iw5eImRjR75 > >										19
268 //	        < 20 ; 38M ; MAR 2021 ; opt. ; - ; 0 ; 1,1902934561942 ; -1 ; -0,00025 ; 0,00025 ; 7,9 ; 8 ; -7,8 ; -8,5 ; -3,1 ; -2,1 ; -0,39 ; NABCHFMA2182 ; dd55DCeB2EA6cffA85EBE7babe0eeabefA5B3FFE4fffC0CEcc36ECCcdC04Db8f ; < l8bH67KcPcaj8y9yFVg9WnfS5HKz4Tq05o8LBB99ic3xMdI2z57Ab813KjoGw1yn > >										20
269 //	        < 21 ; 40M ; MAY 2021 ; opt. ; - ; 0 ; 1,19549991964447 ; -1 ; -0,00025 ; 0,00025 ; 4 ; -3,9 ; 7,4 ; 8,3 ; 7,6 ; 5,3 ; -0,04 ; NABCHFMA2157 ; CFB1A6C4Ca0bA4CCFC25DEcffD7e1Adc275bbADb7A6b2e8fbdfeFcF92c4E0fC8 ; < vbr3PF1T95KfJ25zhXcRJVH0RvZ99U0f3CH67PO3y1XRF48ag9P6959a3rOJC40o > >										21
270 //	        < 22 ; 42M ; JUL 2021 ; opt. ; - ; 0 ; 1,20095391816801 ; -1 ; -0,00025 ; 0,00025 ; -3,9 ; 6,7 ; 6 ; 9,2 ; 8,1 ; 5 ; 0,69 ; NABCHFJU2192 ; Ac72206F728fE1dBcE7eC0CbdFeded8dB78eacABd4fda8DceCcE49EE56DbBDb0 ; < gS0q373tlGLVP1887PTP31Ns9vAk2Np9120eJDCI8ZuM7jYXxMilGzB5jeGw7Fth > >										22
271 //	        < 23 ; 44M ; SEP 2021 ; opt. ; - ; 0 ; 1,2066814556377 ; -1 ; -0,00025 ; 0,00025 ; -7,4 ; 9 ; 8,9 ; -1,2 ; 0,4 ; -1,4 ; -0,11 ; NABCHFSE2185 ; 2E42cD2fE5bBe4fEF6E6bD1c9D8b91AE4B1ec4fDfaFcAba0FfC8CCFeB9c1aecA ; < 5eTK7c6z2SXEavxk8vB09vnEb94Ny89oVr97H0w6QV729bBE87T11F2J1N468G9V > >										23
272 //	        < 24 ; 47M ; DEC 2021 ; opt. ; - ; 0 ; 1,21261742338835 ; -1 ; -0,00025 ; 0,00025 ; 5,3 ; -3,7 ; 9,7 ; -2,1 ; -7,1 ; -3 ; 0,55 ; NABCHFDE2120 ; C2CDEFEAfC5fdC8Dfea8ECFe2bccad7c6E3DDADffaeB529Ce75CBA28A9eD9ccd ; < CBYLN2RPT20f9onrtqx7KYhr06yP7Lf4k15KqwPp58knhKon8339n86L3A3Mh49X > >										24
273 											
274 //	  < CALLS ; 12M ; Strike ; Symbol ; Last ; T(-1) ; Change ; Volume ; BAS_1 ; BAS_2 ; o.i. @ eth_hex ; @ btc_882 >										
275 											
276 //	#DIV/0 !										1
277 //	#DIV/0 !										2
278 //	#DIV/0 !										3
279 //	#DIV/0 !										4
280 //	#DIV/0 !										5
281 //	#DIV/0 !										6
282 //	#DIV/0 !										7
283 //	#DIV/0 !										8
284 //	#DIV/0 !										9
285 //	#DIV/0 !										10
286 //	#DIV/0 !										11
287 //	#DIV/0 !										12
288 //	#DIV/0 !										13
289 //	#DIV/0 !										14
290 //	#DIV/0 !										15
291 //	#DIV/0 !										16
292 //	#DIV/0 !										17
293 //	#DIV/0 !										18
294 //	#DIV/0 !										19
295 //	#DIV/0 !										20
296 //	#DIV/0 !										21
297 //											
298 //	  < PUTS ; 12M ; Strike ; Symbol ; Last ; T(-1) ; Change ; Volume ; BAS_1 ; BAS_2 ; o.i. @ eth_hex ; @ btc_882 >										
299 //											
300 //	#DIV/0 !										1
301 //	#DIV/0 !										2
302 //	#DIV/0 !										3
303 //	#DIV/0 !										4
304 //	#DIV/0 !										5
305 //	#DIV/0 !										6
306 //	#DIV/0 !										7
307 //	#DIV/0 !										8
308 //	#DIV/0 !										9
309 //	#DIV/0 !										10
310 //	#DIV/0 !										11
311 //	#DIV/0 !										12
312 //	#DIV/0 !										13
313 //	#DIV/0 !										14
314 //	#DIV/0 !										15
315 //	#DIV/0 !										16
316 //	#DIV/0 !										17
317 //	#DIV/0 !										18
318 //	#DIV/0 !										19
319 //	#DIV/0 !										20
320 //	#DIV/0 !										21
321 											
322 											
323 											
324 											
325 											
326 //	NABCHF										
327 											
328 //	  < # ; REF ; Month ; Optionchain ; Chart ; Last ; T(-1) ; Change ; BAS_1 ; BAS_2 ; Prior. Settle ; Open ; High ; Low ; Volume ; Hi / Lo ; Updated (s) ; Code ; @ eth_hex ; @ btc_882 >										
329 											
330 //	        < 0 ; T0 ; - ; - ; - ; 0 ; 1,14 ; -1 ; - ; - ; - ; - ; - ; - ; - ; - ; - ; - ; FD28Bf2C6FFDcfdD1A8BC7CcAaAbd5Ac7a87d4CebDadbC9abB2dEbdcAE79F784 ; < k2SR6nfbN2EJ6b2AMWmk65z9T6IqW0Op4GunR162OoXfxchdC4T48T3tG6791U8t > >										0
331 //	        < 1 ; 0M ; JAN 2019 ; opt. ; - ; 0 ; 1,14022012829845 ; -1 ; -0,00025 ; 0,00025 ; 5,5 ; -8,3 ; 9,1 ; -7,1 ; 4,8 ; -1,1 ; 0,59 ; NABCHF93JA19 ; 4baCAA8CFF9BDadE35feA82cC35DaCCA933cFbACacA6dEfE5cE67C9EDAFEeeee ; < B3Os41Ck3UlIYn6efoHq8G439a27R3vltA2LwSDk8gu5q99L42kNicW3OR09k4rR > >										1
332 //	        < 2 ; 2M ; MAR 2019 ; opt. ; - ; 0 ; 1,14079278481714 ; -1 ; -0,00025 ; 0,00025 ; -4,3 ; 0,4 ; 1,5 ; 6,9 ; -2,1 ; -2,7 ; -0,15 ; NABCHFMA1971 ; 7B7DA8CefD8fDfc4cA3f3F04Dfb8C110Af2DFF0D53Ca2d676E638dEe4ED70DD2 ; < 4438Dh6rRPL218n73F05GcN4X626kuVFWqLH3GY0C64RkNeebumBH0sHHbXGz8o2 > >										2
333 //	        < 3 ; 4M ; MAY 2019 ; opt. ; - ; 0 ; 1,14142639814536 ; -1 ; -0,00025 ; 0,00025 ; -6,5 ; 2 ; 2,1 ; -2,3 ; -3,9 ; 4,1 ; 0,1 ; NABCHFMA1948 ; df9fcacB6c9E34Eb7DffC5Aba03a0d0bAceAffe866e7eF1fAb35e6eb811f8ce2 ; < EeuSGuN854799iqt5O4rP19N6nHrlte57b6vPWQTDQuinp9Flq9ersdZX27ikF9t > >										3
334 //	        < 4 ; 6M ; JUL 2019 ; opt. ; - ; 0 ; 1,14237451239954 ; -1 ; -0,00025 ; 0,00025 ; -5 ; -4,9 ; 1,4 ; -1,8 ; -0,8 ; 3,2 ; -0,87 ; NABCHFJU1924 ; 67EBD1Ea5CeC54c7b3daBC0c0f98630653C14faeAdDD1baF7DCEc49aD8bacea4 ; < hX151v3CmklD8T45e1PVeaA84qBqs8GWnva2gfnzZ23O394m1dU1bqTdhf1UI9uc > >										4
335 //	        < 5 ; 8M ; SEP 2019 ; opt. ; - ; 0 ; 1,14346880221948 ; -1 ; -0,00025 ; 0,00025 ; -8,2 ; 1,5 ; -3,7 ; -4,9 ; 4,5 ; 3,3 ; -0,73 ; NABCHFSE1987 ; BEDb9ACaf62f7821BDA4b438Df40Bfa3AE7d8acD2FCC6debfccC6aFbEfC8AaAE ; < J31WMmF5Qsm7M6Hjr5qUiqGMmaqrO81I21u725BJOLPl05020IrW2RnEWp5WpYzR > >										5
336 //	        < 6 ; 11M ; DEC 2019 ; opt. ; - ; 0 ; 1,14479319034117 ; -1 ; -0,00025 ; 0,00025 ; -4,3 ; -7,9 ; 3 ; -1 ; 0,1 ; 6 ; -0,63 ; NABCHFDE1960 ; 0F6ca653C4CfaCbf59FaDaBEca066AA0AABFAa1DabcBf6C7adfC0DCE85aE0aF5 ; < lT9E8P5y0FerM8Bqs0TgzvbassoKKosmqsZDPZH2j8E08OvI2j3KJFTvqxqlqzKm > >										6
337 //	        < 7 ; 12M ; JAN 2020 ; opt. ; - ; 0 ; 1,14644120563189 ; -1 ; -0,00025 ; 0,00025 ; -1,6 ; -9,9 ; -5,6 ; -8,1 ; -8,4 ; -6,2 ; 0,37 ; NABCHFJA2077 ; 4bDeb6eDCd4cca7cB38fc8fF5F1ABc90Ed1D60e4cDf66ca4dB6A25Ac5DA6AAdD ; < V5149966D1F998KNVSa3m63GzQhPH0MwG9i33N1j6J4NK8uk7AE8Z4DQzkR3ZVZ8 > >										7
338 //	        < 8 ; 14M ; MAR 2020 ; opt. ; - ; 0 ; 1,14824338024487 ; -1 ; -0,00025 ; 0,00025 ; 6,7 ; -6 ; -7,7 ; -7,6 ; -2,8 ; -1,1 ; 0,03 ; NABCHFMA2099 ; 3CeaeEA6d0aA862EC9AD34ebCFcDbBECbEABFBadE983FEdCddEaADBd1B0ef312 ; < 32Pg2P27LN8QbDxxzO3958BKft5efCTGal7WF1sL103L8Q30X9bVI5vg06S11v5n > >										8
339 //	        < 9 ; 16M ; MAY 2020 ; opt. ; - ; 0 ; 1,15045766962635 ; -1 ; -0,00025 ; 0,00025 ; -8,7 ; 0,5 ; -3,5 ; 8,2 ; -4,2 ; 4,6 ; 0,82 ; NABCHFMA2098 ; cDdBd07ebbCBEFCCF258AADAbaC8E6d27C5cDA4ca1eb39b8fD2bba28DfeEfbbe ; < Kz2YWe4s3b0YGrea33nPmum0mD9u0L01R82HXxJG98bR0uU34A1xlHaAx7U6m17V > >										9
340 //	        < 10 ; 18M ; JUL 2020 ; opt. ; - ; 0 ; 1,15287006399967 ; -1 ; -0,00025 ; 0,00025 ; -0,3 ; 8,9 ; -9,8 ; 8,7 ; -9,5 ; -7,3 ; -0,14 ; NABCHFJU2099 ; Dd12ac8c52Dd087c0cd55cECBEFD5B916bd4AD7a2FEfa1CEA0Fce6aBe81A2fC1 ; < kM2EOxfPO3JT4H7uZ657721dG6Py386Kmh92BZu5Q712JG3SNArp8oVc36R0u5g0 > >										10
341 //	        < 11 ; 20M ; SEP 2020 ; opt. ; - ; 0 ; 1,15548296118516 ; -1 ; -0,00025 ; 0,00025 ; 2,9 ; 2,5 ; 0,5 ; 2,9 ; -8,5 ; -1 ; 0,9 ; NABCHFSE2027 ; d34aF6d403FE9bF0AFa6EbB3be0Fbcbc0f45e41a5aBf64Addc631eCcEdfDcFeC ; < CZjPtnbenu58McUhXw8wi3oh9Q934V132IV3ydsGDodqZ7X2gOHRIx6Vo0ttlCXA > >										11
342 //	        < 12 ; 23M ; DEC 2020 ; opt. ; - ; 0 ; 1,15846295174206 ; -1 ; -0,00025 ; 0,00025 ; -7,2 ; -8,4 ; -4,9 ; 0,8 ; -7,8 ; 7,8 ; 0,77 ; NABCHFDE2056 ; 5dCfBfE1ABDcc3eefDDF7DffeCeeec3F0BeEf815deEbBa4FAbC3126Bda4BF67a ; < GgPVOrC2U6H1lv5o112V46c75ycvgT6TPVg6Hq6r3t8HuGwi6435cO1d9B98AePv > >										12
343 //	        < 13 ; 24M ; JAN 2021 ; opt. ; - ; 0 ; 1,16149420355209 ; -1 ; -0,00025 ; 0,00025 ; -5,5 ; 9,7 ; 9,3 ; -6,5 ; 7,6 ; 0 ; -0,92 ; NABCHFJA2180 ; 5d8a9eAAf19Ccaf8A0E11Ceb4B3FFEcbD7Ff5dDa7521Db9f821E8CECcAf36430 ; < eQEm0ejeasWYcXX1wD6xK52EXY61eD0OWQIy4Ir8O1R1ts9r79mWeNrLF9a82uNe > >										13
344 //	        < 14 ; 26M ; MAR 2021 ; opt. ; - ; 0 ; 1,16477806578029 ; -1 ; -0,00025 ; 0,00025 ; -2,6 ; -4,3 ; 6,4 ; 6,3 ; 9,9 ; -5,5 ; -0,35 ; NABCHFMA2159 ; A2Af98F1d8dC19DFaefF71AD1cD4Cd07ba3642BbdEDF44ceAcdD9E3DF575DED4 ; < hd5Fu8gTt7QH50zOsmBDlJSKD28cq3XFyCv56Iuw1kR1JD6My8mNVKn0T57EtRB8 > >										14
345 //	        < 15 ; 28M ; MAY 2021 ; opt. ; - ; 0 ; 1,16836089510099 ; -1 ; -0,00025 ; 0,00025 ; 5,1 ; -0,1 ; 6,2 ; -5,2 ; -6,5 ; 0,4 ; -0,23 ; NABCHFMA2124 ; cDABAE2e1a3162465267EeB9d0AcB53FFD95dDEB72d841a9d6A9a8Ea4391aCFE ; < e2G46C2DH1se80c7378ebrk7Qp987qikfs15kB08HdD172Er28B2bYC9a25zty89 > >										15
346 //	        < 16 ; 30M ; JUL 2021 ; opt. ; - ; 0 ; 1,1723014509549 ; -1 ; -0,00025 ; 0,00025 ; 5,6 ; -1,7 ; 0,2 ; 6,8 ; 5,3 ; -8,1 ; -0,1 ; NABCHFJU2171 ; 01F0e9d1E2C2EeF2FbD35f0b1dcDdAFDAE3Df7DF5Cc609AA402D3c0db9f7b937 ; < bLt7wJY87zBEpGxwA9y5reIGGDi5cBGy8OdeXYJ5k6wBoELWaNJ04q3lZg6Q2cNF > >										16
347 //	        < 17 ; 32M ; SEP 2021 ; opt. ; - ; 0 ; 1,17637345222373 ; -1 ; -0,00025 ; 0,00025 ; -2,2 ; 4,1 ; -6,8 ; 2,7 ; 6 ; 7,3 ; 0,03 ; NABCHFSE2171 ; C6faBfC0B002cE02a9db6FCEEbac204F9E1e3AD47e8e47eef5B2ddedcD6Cc6ea ; < XXfLDU2fM2iY8PPKg4n6fu7hTC07R0IedjydF0vf25gZNC3ljGQLO3cX9JTvp7Ii > >										17
348 //	        < 18 ; 35M ; DEC 2021 ; opt. ; - ; 0 ; 1,18067702954261 ; -1 ; -0,00025 ; 0,00025 ; -7,3 ; 9,1 ; 0,8 ; 6,7 ; -2 ; 2,2 ; 0,6 ; NABCHFDE2113 ; AD5bfdbf7ECBF1fEa63E4Ee0fFAEAD0dE8aE69e3401809F6DcF4DdBcF4bCF3FA ; < 7L8oAqY376Xn2xSoxRYLGD5LN0tQZ45E9NTmT7E7mOMlh6ecjEqkLngqKigur25A > >										18
349 //	        < 19 ; 36M ; JAN 2021 ; opt. ; - ; 0 ; 1,18526067588708 ; -1 ; -0,00025 ; 0,00025 ; 5,7 ; 1,1 ; 3,4 ; -8 ; 4,8 ; 6,3 ; -0,72 ; NABCHFJA2141 ; dACeBdB2ffBecDffdC6AEc8aa2aaA7443ab94cEf6Bbb4Fd56bBDbde5DA8EcAbf ; < 11rvxSPZGo60UkKY1vxRRwmHD8wXA7iuTk5aB40XNq3t2dxRr13l8Iw5eImRjR75 > >										19
350 //	        < 20 ; 38M ; MAR 2021 ; opt. ; - ; 0 ; 1,1902934561942 ; -1 ; -0,00025 ; 0,00025 ; 7,9 ; 8 ; -7,8 ; -8,5 ; -3,1 ; -2,1 ; -0,39 ; NABCHFMA2182 ; dd55DCeB2EA6cffA85EBE7babe0eeabefA5B3FFE4fffC0CEcc36ECCcdC04Db8f ; < l8bH67KcPcaj8y9yFVg9WnfS5HKz4Tq05o8LBB99ic3xMdI2z57Ab813KjoGw1yn > >										20
351 //	        < 21 ; 40M ; MAY 2021 ; opt. ; - ; 0 ; 1,19549991964447 ; -1 ; -0,00025 ; 0,00025 ; 4 ; -3,9 ; 7,4 ; 8,3 ; 7,6 ; 5,3 ; -0,04 ; NABCHFMA2157 ; CFB1A6C4Ca0bA4CCFC25DEcffD7e1Adc275bbADb7A6b2e8fbdfeFcF92c4E0fC8 ; < vbr3PF1T95KfJ25zhXcRJVH0RvZ99U0f3CH67PO3y1XRF48ag9P6959a3rOJC40o > >										21
352 //	        < 22 ; 42M ; JUL 2021 ; opt. ; - ; 0 ; 1,20095391816801 ; -1 ; -0,00025 ; 0,00025 ; -3,9 ; 6,7 ; 6 ; 9,2 ; 8,1 ; 5 ; 0,69 ; NABCHFJU2192 ; Ac72206F728fE1dBcE7eC0CbdFeded8dB78eacABd4fda8DceCcE49EE56DbBDb0 ; < gS0q373tlGLVP1887PTP31Ns9vAk2Np9120eJDCI8ZuM7jYXxMilGzB5jeGw7Fth > >										22
353 //	        < 23 ; 44M ; SEP 2021 ; opt. ; - ; 0 ; 1,2066814556377 ; -1 ; -0,00025 ; 0,00025 ; -7,4 ; 9 ; 8,9 ; -1,2 ; 0,4 ; -1,4 ; -0,11 ; NABCHFSE2185 ; 2E42cD2fE5bBe4fEF6E6bD1c9D8b91AE4B1ec4fDfaFcAba0FfC8CCFeB9c1aecA ; < 5eTK7c6z2SXEavxk8vB09vnEb94Ny89oVr97H0w6QV729bBE87T11F2J1N468G9V > >										23
354 //	        < 24 ; 47M ; DEC 2021 ; opt. ; - ; 0 ; 1,21261742338835 ; -1 ; -0,00025 ; 0,00025 ; 5,3 ; -3,7 ; 9,7 ; -2,1 ; -7,1 ; -3 ; 0,55 ; NABCHFDE2120 ; C2CDEFEAfC5fdC8Dfea8ECFe2bccad7c6E3DDADffaeB529Ce75CBA28A9eD9ccd ; < CBYLN2RPT20f9onrtqx7KYhr06yP7Lf4k15KqwPp58knhKon8339n86L3A3Mh49X > >										24
355 											
356 //	  < CALLS ; 24M ; Strike ; Symbol ; Last ; T(-1) ; Change ; Volume ; BAS_1 ; BAS_2 ; o.i. @ eth_hex ; @ btc_882 >										
357 											
358 //	#DIV/0 !										1
359 //	#DIV/0 !										2
360 //	#DIV/0 !										3
361 //	#DIV/0 !										4
362 //	#DIV/0 !										5
363 //	#DIV/0 !										6
364 //	#DIV/0 !										7
365 //	#DIV/0 !										8
366 //	#DIV/0 !										9
367 //	#DIV/0 !										10
368 //	#DIV/0 !										11
369 //	#DIV/0 !										12
370 //	#DIV/0 !										13
371 //	#DIV/0 !										14
372 //	#DIV/0 !										15
373 //	#DIV/0 !										16
374 //	#DIV/0 !										17
375 //	#DIV/0 !										18
376 //	#DIV/0 !										19
377 //	#DIV/0 !										20
378 //	#DIV/0 !										21
379 //											
380 //	  < PUTS ; 24M ; Strike ; Symbol ; Last ; T(-1) ; Change ; Volume ; BAS_1 ; BAS_2 ; o.i. @ eth_hex ; @ btc_882 >										
381 //											
382 //	#DIV/0 !										1
383 //	#DIV/0 !										2
384 //	#DIV/0 !										3
385 //	#DIV/0 !										4
386 //	#DIV/0 !										5
387 //	#DIV/0 !										6
388 //	#DIV/0 !										7
389 //	#DIV/0 !										8
390 //	#DIV/0 !										9
391 //	#DIV/0 !										10
392 //	#DIV/0 !										11
393 //	#DIV/0 !										12
394 //	#DIV/0 !										13
395 //	#DIV/0 !										14
396 //	#DIV/0 !										15
397 //	#DIV/0 !										16
398 //	#DIV/0 !										17
399 //	#DIV/0 !										18
400 //	#DIV/0 !										19
401 //	#DIV/0 !										20
402 //	#DIV/0 !										21
403 											
404 											
405 											
406 											
407 											
408 //	NABCHF										
409 											
410 //	  < # ; REF ; Month ; Optionchain ; Chart ; Last ; T(-1) ; Change ; BAS_1 ; BAS_2 ; Prior. Settle ; Open ; High ; Low ; Volume ; Hi / Lo ; Updated (s) ; Code ; @ eth_hex ; @ btc_882 >										
411 											
412 //	        < 0 ; T0 ; - ; - ; - ; 0 ; 1,14 ; -1 ; - ; - ; - ; - ; - ; - ; - ; - ; - ; - ; FD28Bf2C6FFDcfdD1A8BC7CcAaAbd5Ac7a87d4CebDadbC9abB2dEbdcAE79F784 ; < k2SR6nfbN2EJ6b2AMWmk65z9T6IqW0Op4GunR162OoXfxchdC4T48T3tG6791U8t > >										0
413 //	        < 1 ; 0M ; JAN 2019 ; opt. ; - ; 0 ; 1,14022012829845 ; -1 ; -0,00025 ; 0,00025 ; 5,5 ; -8,3 ; 9,1 ; -7,1 ; 4,8 ; -1,1 ; 0,59 ; NABCHF93JA19 ; 4baCAA8CFF9BDadE35feA82cC35DaCCA933cFbACacA6dEfE5cE67C9EDAFEeeee ; < B3Os41Ck3UlIYn6efoHq8G439a27R3vltA2LwSDk8gu5q99L42kNicW3OR09k4rR > >										1
414 //	        < 2 ; 2M ; MAR 2019 ; opt. ; - ; 0 ; 1,14079278481714 ; -1 ; -0,00025 ; 0,00025 ; -4,3 ; 0,4 ; 1,5 ; 6,9 ; -2,1 ; -2,7 ; -0,15 ; NABCHFMA1971 ; 7B7DA8CefD8fDfc4cA3f3F04Dfb8C110Af2DFF0D53Ca2d676E638dEe4ED70DD2 ; < 4438Dh6rRPL218n73F05GcN4X626kuVFWqLH3GY0C64RkNeebumBH0sHHbXGz8o2 > >										2
415 //	        < 3 ; 4M ; MAY 2019 ; opt. ; - ; 0 ; 1,14142639814536 ; -1 ; -0,00025 ; 0,00025 ; -6,5 ; 2 ; 2,1 ; -2,3 ; -3,9 ; 4,1 ; 0,1 ; NABCHFMA1948 ; df9fcacB6c9E34Eb7DffC5Aba03a0d0bAceAffe866e7eF1fAb35e6eb811f8ce2 ; < EeuSGuN854799iqt5O4rP19N6nHrlte57b6vPWQTDQuinp9Flq9ersdZX27ikF9t > >										3
416 //	        < 4 ; 6M ; JUL 2019 ; opt. ; - ; 0 ; 1,14237451239954 ; -1 ; -0,00025 ; 0,00025 ; -5 ; -4,9 ; 1,4 ; -1,8 ; -0,8 ; 3,2 ; -0,87 ; NABCHFJU1924 ; 67EBD1Ea5CeC54c7b3daBC0c0f98630653C14faeAdDD1baF7DCEc49aD8bacea4 ; < hX151v3CmklD8T45e1PVeaA84qBqs8GWnva2gfnzZ23O394m1dU1bqTdhf1UI9uc > >										4
417 //	        < 5 ; 8M ; SEP 2019 ; opt. ; - ; 0 ; 1,14346880221948 ; -1 ; -0,00025 ; 0,00025 ; -8,2 ; 1,5 ; -3,7 ; -4,9 ; 4,5 ; 3,3 ; -0,73 ; NABCHFSE1987 ; BEDb9ACaf62f7821BDA4b438Df40Bfa3AE7d8acD2FCC6debfccC6aFbEfC8AaAE ; < J31WMmF5Qsm7M6Hjr5qUiqGMmaqrO81I21u725BJOLPl05020IrW2RnEWp5WpYzR > >										5
418 //	        < 6 ; 11M ; DEC 2019 ; opt. ; - ; 0 ; 1,14479319034117 ; -1 ; -0,00025 ; 0,00025 ; -4,3 ; -7,9 ; 3 ; -1 ; 0,1 ; 6 ; -0,63 ; NABCHFDE1960 ; 0F6ca653C4CfaCbf59FaDaBEca066AA0AABFAa1DabcBf6C7adfC0DCE85aE0aF5 ; < lT9E8P5y0FerM8Bqs0TgzvbassoKKosmqsZDPZH2j8E08OvI2j3KJFTvqxqlqzKm > >										6
419 //	        < 7 ; 12M ; JAN 2020 ; opt. ; - ; 0 ; 1,14644120563189 ; -1 ; -0,00025 ; 0,00025 ; -1,6 ; -9,9 ; -5,6 ; -8,1 ; -8,4 ; -6,2 ; 0,37 ; NABCHFJA2077 ; 4bDeb6eDCd4cca7cB38fc8fF5F1ABc90Ed1D60e4cDf66ca4dB6A25Ac5DA6AAdD ; < V5149966D1F998KNVSa3m63GzQhPH0MwG9i33N1j6J4NK8uk7AE8Z4DQzkR3ZVZ8 > >										7
420 //	        < 8 ; 14M ; MAR 2020 ; opt. ; - ; 0 ; 1,14824338024487 ; -1 ; -0,00025 ; 0,00025 ; 6,7 ; -6 ; -7,7 ; -7,6 ; -2,8 ; -1,1 ; 0,03 ; NABCHFMA2099 ; 3CeaeEA6d0aA862EC9AD34ebCFcDbBECbEABFBadE983FEdCddEaADBd1B0ef312 ; < 32Pg2P27LN8QbDxxzO3958BKft5efCTGal7WF1sL103L8Q30X9bVI5vg06S11v5n > >										8
421 //	        < 9 ; 16M ; MAY 2020 ; opt. ; - ; 0 ; 1,15045766962635 ; -1 ; -0,00025 ; 0,00025 ; -8,7 ; 0,5 ; -3,5 ; 8,2 ; -4,2 ; 4,6 ; 0,82 ; NABCHFMA2098 ; cDdBd07ebbCBEFCCF258AADAbaC8E6d27C5cDA4ca1eb39b8fD2bba28DfeEfbbe ; < Kz2YWe4s3b0YGrea33nPmum0mD9u0L01R82HXxJG98bR0uU34A1xlHaAx7U6m17V > >										9
422 //	        < 10 ; 18M ; JUL 2020 ; opt. ; - ; 0 ; 1,15287006399967 ; -1 ; -0,00025 ; 0,00025 ; -0,3 ; 8,9 ; -9,8 ; 8,7 ; -9,5 ; -7,3 ; -0,14 ; NABCHFJU2099 ; Dd12ac8c52Dd087c0cd55cECBEFD5B916bd4AD7a2FEfa1CEA0Fce6aBe81A2fC1 ; < kM2EOxfPO3JT4H7uZ657721dG6Py386Kmh92BZu5Q712JG3SNArp8oVc36R0u5g0 > >										10
423 //	        < 11 ; 20M ; SEP 2020 ; opt. ; - ; 0 ; 1,15548296118516 ; -1 ; -0,00025 ; 0,00025 ; 2,9 ; 2,5 ; 0,5 ; 2,9 ; -8,5 ; -1 ; 0,9 ; NABCHFSE2027 ; d34aF6d403FE9bF0AFa6EbB3be0Fbcbc0f45e41a5aBf64Addc631eCcEdfDcFeC ; < CZjPtnbenu58McUhXw8wi3oh9Q934V132IV3ydsGDodqZ7X2gOHRIx6Vo0ttlCXA > >										11
424 //	        < 12 ; 23M ; DEC 2020 ; opt. ; - ; 0 ; 1,15846295174206 ; -1 ; -0,00025 ; 0,00025 ; -7,2 ; -8,4 ; -4,9 ; 0,8 ; -7,8 ; 7,8 ; 0,77 ; NABCHFDE2056 ; 5dCfBfE1ABDcc3eefDDF7DffeCeeec3F0BeEf815deEbBa4FAbC3126Bda4BF67a ; < GgPVOrC2U6H1lv5o112V46c75ycvgT6TPVg6Hq6r3t8HuGwi6435cO1d9B98AePv > >										12
425 //	        < 13 ; 24M ; JAN 2021 ; opt. ; - ; 0 ; 1,16149420355209 ; -1 ; -0,00025 ; 0,00025 ; -5,5 ; 9,7 ; 9,3 ; -6,5 ; 7,6 ; 0 ; -0,92 ; NABCHFJA2180 ; 5d8a9eAAf19Ccaf8A0E11Ceb4B3FFEcbD7Ff5dDa7521Db9f821E8CECcAf36430 ; < eQEm0ejeasWYcXX1wD6xK52EXY61eD0OWQIy4Ir8O1R1ts9r79mWeNrLF9a82uNe > >										13
426 //	        < 14 ; 26M ; MAR 2021 ; opt. ; - ; 0 ; 1,16477806578029 ; -1 ; -0,00025 ; 0,00025 ; -2,6 ; -4,3 ; 6,4 ; 6,3 ; 9,9 ; -5,5 ; -0,35 ; NABCHFMA2159 ; A2Af98F1d8dC19DFaefF71AD1cD4Cd07ba3642BbdEDF44ceAcdD9E3DF575DED4 ; < hd5Fu8gTt7QH50zOsmBDlJSKD28cq3XFyCv56Iuw1kR1JD6My8mNVKn0T57EtRB8 > >										14
427 //	        < 15 ; 28M ; MAY 2021 ; opt. ; - ; 0 ; 1,16836089510099 ; -1 ; -0,00025 ; 0,00025 ; 5,1 ; -0,1 ; 6,2 ; -5,2 ; -6,5 ; 0,4 ; -0,23 ; NABCHFMA2124 ; cDABAE2e1a3162465267EeB9d0AcB53FFD95dDEB72d841a9d6A9a8Ea4391aCFE ; < e2G46C2DH1se80c7378ebrk7Qp987qikfs15kB08HdD172Er28B2bYC9a25zty89 > >										15
428 //	        < 16 ; 30M ; JUL 2021 ; opt. ; - ; 0 ; 1,1723014509549 ; -1 ; -0,00025 ; 0,00025 ; 5,6 ; -1,7 ; 0,2 ; 6,8 ; 5,3 ; -8,1 ; -0,1 ; NABCHFJU2171 ; 01F0e9d1E2C2EeF2FbD35f0b1dcDdAFDAE3Df7DF5Cc609AA402D3c0db9f7b937 ; < bLt7wJY87zBEpGxwA9y5reIGGDi5cBGy8OdeXYJ5k6wBoELWaNJ04q3lZg6Q2cNF > >										16
429 //	        < 17 ; 32M ; SEP 2021 ; opt. ; - ; 0 ; 1,17637345222373 ; -1 ; -0,00025 ; 0,00025 ; -2,2 ; 4,1 ; -6,8 ; 2,7 ; 6 ; 7,3 ; 0,03 ; NABCHFSE2171 ; C6faBfC0B002cE02a9db6FCEEbac204F9E1e3AD47e8e47eef5B2ddedcD6Cc6ea ; < XXfLDU2fM2iY8PPKg4n6fu7hTC07R0IedjydF0vf25gZNC3ljGQLO3cX9JTvp7Ii > >										17
430 //	        < 18 ; 35M ; DEC 2021 ; opt. ; - ; 0 ; 1,18067702954261 ; -1 ; -0,00025 ; 0,00025 ; -7,3 ; 9,1 ; 0,8 ; 6,7 ; -2 ; 2,2 ; 0,6 ; NABCHFDE2113 ; AD5bfdbf7ECBF1fEa63E4Ee0fFAEAD0dE8aE69e3401809F6DcF4DdBcF4bCF3FA ; < 7L8oAqY376Xn2xSoxRYLGD5LN0tQZ45E9NTmT7E7mOMlh6ecjEqkLngqKigur25A > >										18
431 //	        < 19 ; 36M ; JAN 2021 ; opt. ; - ; 0 ; 1,18526067588708 ; -1 ; -0,00025 ; 0,00025 ; 5,7 ; 1,1 ; 3,4 ; -8 ; 4,8 ; 6,3 ; -0,72 ; NABCHFJA2141 ; dACeBdB2ffBecDffdC6AEc8aa2aaA7443ab94cEf6Bbb4Fd56bBDbde5DA8EcAbf ; < 11rvxSPZGo60UkKY1vxRRwmHD8wXA7iuTk5aB40XNq3t2dxRr13l8Iw5eImRjR75 > >										19
432 //	        < 20 ; 38M ; MAR 2021 ; opt. ; - ; 0 ; 1,1902934561942 ; -1 ; -0,00025 ; 0,00025 ; 7,9 ; 8 ; -7,8 ; -8,5 ; -3,1 ; -2,1 ; -0,39 ; NABCHFMA2182 ; dd55DCeB2EA6cffA85EBE7babe0eeabefA5B3FFE4fffC0CEcc36ECCcdC04Db8f ; < l8bH67KcPcaj8y9yFVg9WnfS5HKz4Tq05o8LBB99ic3xMdI2z57Ab813KjoGw1yn > >										20
433 //	        < 21 ; 40M ; MAY 2021 ; opt. ; - ; 0 ; 1,19549991964447 ; -1 ; -0,00025 ; 0,00025 ; 4 ; -3,9 ; 7,4 ; 8,3 ; 7,6 ; 5,3 ; -0,04 ; NABCHFMA2157 ; CFB1A6C4Ca0bA4CCFC25DEcffD7e1Adc275bbADb7A6b2e8fbdfeFcF92c4E0fC8 ; < vbr3PF1T95KfJ25zhXcRJVH0RvZ99U0f3CH67PO3y1XRF48ag9P6959a3rOJC40o > >										21
434 //	        < 22 ; 42M ; JUL 2021 ; opt. ; - ; 0 ; 1,20095391816801 ; -1 ; -0,00025 ; 0,00025 ; -3,9 ; 6,7 ; 6 ; 9,2 ; 8,1 ; 5 ; 0,69 ; NABCHFJU2192 ; Ac72206F728fE1dBcE7eC0CbdFeded8dB78eacABd4fda8DceCcE49EE56DbBDb0 ; < gS0q373tlGLVP1887PTP31Ns9vAk2Np9120eJDCI8ZuM7jYXxMilGzB5jeGw7Fth > >										22
435 //	        < 23 ; 44M ; SEP 2021 ; opt. ; - ; 0 ; 1,2066814556377 ; -1 ; -0,00025 ; 0,00025 ; -7,4 ; 9 ; 8,9 ; -1,2 ; 0,4 ; -1,4 ; -0,11 ; NABCHFSE2185 ; 2E42cD2fE5bBe4fEF6E6bD1c9D8b91AE4B1ec4fDfaFcAba0FfC8CCFeB9c1aecA ; < 5eTK7c6z2SXEavxk8vB09vnEb94Ny89oVr97H0w6QV729bBE87T11F2J1N468G9V > >										23
436 //	        < 24 ; 47M ; DEC 2021 ; opt. ; - ; 0 ; 1,21261742338835 ; -1 ; -0,00025 ; 0,00025 ; 5,3 ; -3,7 ; 9,7 ; -2,1 ; -7,1 ; -3 ; 0,55 ; NABCHFDE2120 ; C2CDEFEAfC5fdC8Dfea8ECFe2bccad7c6E3DDADffaeB529Ce75CBA28A9eD9ccd ; < CBYLN2RPT20f9onrtqx7KYhr06yP7Lf4k15KqwPp58knhKon8339n86L3A3Mh49X > >										24
437 											
438 //	  < CALLS ; 36M ; Strike ; Symbol ; Last ; T(-1) ; Change ; Volume ; BAS_1 ; BAS_2 ; o.i. @ eth_hex ; @ btc_882 >										
439 											
440 //	#DIV/0 !										1
441 //	#DIV/0 !										2
442 //	#DIV/0 !										3
443 //	#DIV/0 !										4
444 //	#DIV/0 !										5
445 //	#DIV/0 !										6
446 //	#DIV/0 !										7
447 //	#DIV/0 !										8
448 //	#DIV/0 !										9
449 //	#DIV/0 !										10
450 //	#DIV/0 !										11
451 //	#DIV/0 !										12
452 //	#DIV/0 !										13
453 //	#DIV/0 !										14
454 //	#DIV/0 !										15
455 //	#DIV/0 !										16
456 //	#DIV/0 !										17
457 //	#DIV/0 !										18
458 //	#DIV/0 !										19
459 //	#DIV/0 !										20
460 //	#DIV/0 !										21
461 //											
462 //	  < PUTS ; 36M ; Strike ; Symbol ; Last ; T(-1) ; Change ; Volume ; BAS_1 ; BAS_2 ; o.i. @ eth_hex ; @ btc_882 >										
463 //											
464 //	#DIV/0 !										1
465 //	#DIV/0 !										2
466 //	#DIV/0 !										3
467 //	#DIV/0 !										4
468 //	#DIV/0 !										5
469 //	#DIV/0 !										6
470 //	#DIV/0 !										7
471 //	#DIV/0 !										8
472 //	#DIV/0 !										9
473 //	#DIV/0 !										10
474 //	#DIV/0 !										11
475 //	#DIV/0 !										12
476 //	#DIV/0 !										13
477 //	#DIV/0 !										14
478 //	#DIV/0 !										15
479 //	#DIV/0 !										16
480 //	#DIV/0 !										17
481 //	#DIV/0 !										18
482 //	#DIV/0 !										19
483 //	#DIV/0 !										20
484 //	#DIV/0 !										21
485 											
486 											
487 											
488 											
489 											
490 //	NABEUR										
491 											
492 //	  < # ; REF ; Month ; Optionchain ; Chart ; Last ; T(-1) ; Change ; BAS_1 ; BAS_2 ; Prior. Settle ; Open ; High ; Low ; Volume ; Hi / Lo ; Updated (s) ; Code ; @ eth_hex ; @ btc_882 >										
493 											
494 //	        < 0 ; T0 ; - ; - ; - ; 0 ; 1 ; -1 ; - ; - ; - ; - ; - ; - ; - ; - ; - ; - ; f4AddAd7aaAc515DCFAD905Cc3Efa08cfEae8EF5Ae1F63Dfe7bcDcf23bf77ADA ; < to6Od76JFlu03IYs1nj527h6uJlLLYTm5282x757SG997ww449E1a0tZHpw467da > >										0
495 //	        < 1 ; 0M ; JAN 2019 ; opt. ; - ; 0 ; 1,00026609499864 ; -1 ; -0,00025 ; 0,00025 ; -6 ; -0,2 ; 1,6 ; -5,3 ; -3,6 ; 6,5 ; -0,06 ; NABEUR26JA19 ; f2C9dDE6b26A4bADEe4cc9Ef2FedAbEDabEa2BDBBFB21Fdd3C0f0edBFDca2Bb6 ; < 92J4ya37SZ0k76941BELR494r7qJeZg8C18qkS6mWlQ8bA5JwIH780AjpGZvxEtr > >										1
496 //	        < 2 ; 2M ; MAR 2019 ; opt. ; - ; 0 ; 1,00074045449057 ; -1 ; -0,00025 ; 0,00025 ; 2,5 ; 3,6 ; 6,8 ; -8,6 ; -3,6 ; -7,6 ; 0,53 ; NABEURMA1936 ; 76CADAa0dCAD4f9e28BC74fE36eeFBEfE0c9CACE2b9776e55b0FBF5Ae847c9e6 ; < aDwt79SowQO5Jght4jMa4q9HbJ4Dxg3sCHyK6E5K38KNkMxxUw4RYF1B9J4eQ8LM > >										2
497 //	        < 3 ; 4M ; MAY 2019 ; opt. ; - ; 0 ; 1,00137633990192 ; -1 ; -0,00025 ; 0,00025 ; 9,4 ; 7,9 ; 9,5 ; -8,5 ; -0,4 ; -7,6 ; 0,86 ; NABEURMA1934 ; 7fdCCd9bCcFdFA6cDA36ACD1EBFC173C70Fb9BfE9BBe952efbAADfb890622c2a ; < jO618x9ekJ1Lv1XC0A6q53yEWscZpiC7RB7da97L32bR5r6aIPm75DW7CWFBYA06 > >										3
498 //	        < 4 ; 6M ; JUL 2019 ; opt. ; - ; 0 ; 1,002286230351 ; -1 ; -0,00025 ; 0,00025 ; 7,4 ; 4,8 ; 7,4 ; 5,6 ; 9 ; -8,7 ; 0,63 ; NABEURJU1956 ; adeb1be4CaC7CEC2FF6B8Def4B04EdAebEa0ab08Ee40F632ceEDad3Ae3770C7f ; < h9KiF3XQO1ce6oS1qkKn5dfEBRA2YR35c1P159gH27JPFu8i0HHQP8q3P1ZZ23eq > >										4
499 //	        < 5 ; 8M ; SEP 2019 ; opt. ; - ; 0 ; 1,00336860738833 ; -1 ; -0,00025 ; 0,00025 ; 7 ; -8,3 ; 0,7 ; -1,5 ; 4,5 ; -8,1 ; -0,59 ; NABEURSE1946 ; CaE2261bbaf5cBECBFdCfB4Ad2Ea2473fFd8BC7bD0f8F73dFACccECC1DBDc6af ; < zsRU1zArGtZiy309z3k2C00WdGVErZ7O1t9W7FO7r3BOP9E620ldq9GP588bB5I8 > >										5
500 //	        < 6 ; 11M ; DEC 2019 ; opt. ; - ; 0 ; 1,00464410935353 ; -1 ; -0,00025 ; 0,00025 ; 5,4 ; -8 ; 7,6 ; -1 ; 4,6 ; 1,2 ; -0,37 ; NABEURDE1943 ; 3D9e234BA02FAcb1DaF3CaBCFE91361BD1afdC9eD42abc453C4b2fAACd8409E0 ; < gpAZ47OvET1pRg0pQD87yqF84pUinmn5pVX73kshaPTMK3JqV54qC2Kaz9Q1cWwk > >										6
501 //	        < 7 ; 12M ; JAN 2020 ; opt. ; - ; 0 ; 1,00601301197941 ; -1 ; -0,00025 ; 0,00025 ; -8 ; -9,1 ; -9,1 ; 2,3 ; 7 ; -9,7 ; 0,13 ; NABEURJA2055 ; daacACddFE3abFf12fafdcA7eDbE4aD49fDd4303a6b6bF2fAa8F356EDA38bfA4 ; < OlTW7ZyeVHBImUL1ezKLrK2q52204WYB2JSG010aD0q96AGc71pbJT4LknHOVU3t > >										7
502 //	        < 8 ; 14M ; MAR 2020 ; opt. ; - ; 0 ; 1,00770107464382 ; -1 ; -0,00025 ; 0,00025 ; 7,3 ; -4 ; -5,2 ; 9,8 ; -5 ; -3,8 ; -0,64 ; NABEURMA2056 ; 1AEbCbe8FdB51bFd1fA455eFcBAB42FdFCffEebb0eF2fAC8BC554Ab08d0Eed1A ; < J50jNaOyxAQ1Omzu54ljn1NWB5XwUfw4XRf8MPavU6ux411J3t8o2xTg2dfYe3GP > >										8
503 //	        < 9 ; 16M ; MAY 2020 ; opt. ; - ; 0 ; 1,00951031593822 ; -1 ; -0,00025 ; 0,00025 ; -7,1 ; -6,6 ; 0,3 ; 3,6 ; 6,2 ; 3,2 ; 0,96 ; NABEURMA2075 ; FbdFB31EDa92e4ACfa6BddcFFdAbbDe5AEBAefF333Cb8BaDaebAd1afaCA1Bdef ; < C4T3SI0er22kd1B9Y2xZ278uMS9ODlZ1ZM5219wwxtKO2OfmW013g2ww084GE67H > >										9
504 //	        < 10 ; 18M ; JUL 2020 ; opt. ; - ; 0 ; 1,01152216877121 ; -1 ; -0,00025 ; 0,00025 ; -6,6 ; 9,2 ; -0,7 ; 9,9 ; -9,4 ; -2,6 ; -0,7 ; NABEURJU2059 ; A0fac1445fdb0efdAd67F5Ecb1ddfaCa4a5d8e6feaF607FbAd6DfDdaA8f3ec83 ; < 9t2I3N9CkAxA1waJ8ab1ELsq0mf89UK09bju9P9f6K61644nS7N6N4iwsVmgmD3k > >										10
505 //	        < 11 ; 20M ; SEP 2020 ; opt. ; - ; 0 ; 1,01378335391844 ; -1 ; -0,00025 ; 0,00025 ; -3 ; 5,2 ; 7 ; -4,3 ; 3,6 ; 1,8 ; -0,59 ; NABEURSE2053 ; EaEdBEAe86B8cB9C2a751ffdfFdf3Ce5EAf5D43eFBc41BfB3CFbCc8ecbbfeFbc ; < 6w6EFb938Y06481OxD1H2XU04EW50N34ure7877Jld7KRIo4SeiJLHZMO61fP06B > >										11
506 //	        < 12 ; 23M ; DEC 2020 ; opt. ; - ; 0 ; 1,0162438061184 ; -1 ; -0,00025 ; 0,00025 ; -7,7 ; -5,3 ; -4,3 ; 5,5 ; -5,5 ; -2,8 ; -0,75 ; NABEURDE2057 ; DbEaec74bf0cbB8CF2A6E8b0C1dE278c8B1fE1bf5bFcFeFdB1E2D8a97feDd8ee ; < no7gRb56drzRvI6b0a6Z96j3ztslj3j91kB539IP85Eut44t8ojq3Ybm8p0993FW > >										12
507 //	        < 13 ; 24M ; JAN 2021 ; opt. ; - ; 0 ; 1,01890292514512 ; -1 ; -0,00025 ; 0,00025 ; -2,5 ; -8,7 ; -2,6 ; -8,1 ; 3,3 ; 0 ; -0,2 ; NABEURJA2184 ; e8a1C0Fb1cB82AFecfAeF633ce61C4fF27dd1dbA9a6a7BCCe0EDacb9BBf9fCC9 ; < yrSx9HtjYOKzdDaGEWkgozy66NT58969kek0S4zf2M1107g3QD1cgc7hC6AU6pQY > >										13
508 //	        < 14 ; 26M ; MAR 2021 ; opt. ; - ; 0 ; 1,02188145745659 ; -1 ; -0,00025 ; 0,00025 ; 4,9 ; -1,2 ; 0,8 ; 7,5 ; -9,7 ; -7 ; 0,25 ; NABEURMA2199 ; eed7645f2aEFB2dDA36E6db1bdAcD7e1a3e02F1c9909Ad58f19771d8faBa9bB7 ; < 8p38h80WchAdR6NnkqZ3zt7yzBG154moJMa4X2RA7ST6HE5P2OfNO3gVOX2F7y1a > >										14
509 //	        < 15 ; 28M ; MAY 2021 ; opt. ; - ; 0 ; 1,02507276867486 ; -1 ; -0,00025 ; 0,00025 ; -8,3 ; -2,8 ; -7,8 ; 2,9 ; 0,8 ; -9,8 ; 0,87 ; NABEURMA2196 ; A70eE4aa2c95BDFc8c6a3b2A65c8E0f8AEafaab8aFecdCdE1bFf4Ce3f2e4fDCA ; < 1X5SWJzdl11a96EYU91pO1QrGgGY3kP71T02a13XHhm7t21Y8B86Q5266x4w336K > >										15
510 //	        < 16 ; 30M ; JUL 2021 ; opt. ; - ; 0 ; 1,02853312880934 ; -1 ; -0,00025 ; 0,00025 ; -4,4 ; -9,2 ; -7,9 ; 1,8 ; 9,6 ; -6,9 ; -0,73 ; NABEURJU2190 ; fACf6b8d0efa5B1dcD50e8Fd7EcEf1F7BdBeBcca6cef79DbbD422b83DFBF6698 ; < 6PrBR9h1YW7g9Yqe7O057q7eT0vYzVo60H2GIzTs7gqq82r0JnqP9t6wD2shDNxF > >										16
511 //	        < 17 ; 32M ; SEP 2021 ; opt. ; - ; 0 ; 1,03216540423907 ; -1 ; -0,00025 ; 0,00025 ; 6,1 ; -9 ; -2,8 ; 2,8 ; -9,6 ; -7 ; 0,56 ; NABEURSE2158 ; AdDfB4A3dddce7dBfdE8bA8Ce4E07f9fF63CaAFEcDCE76FbecA7B88eE0a7bFB4 ; < 456vbWlP96q6h6MPmEBLLWUKnb02lVUJVwwZOB8f8z56UTquQ6E1U6pUy41sg2nt > >										17
512 //	        < 18 ; 35M ; DEC 2021 ; opt. ; - ; 0 ; 1,03597754487675 ; -1 ; -0,00025 ; 0,00025 ; 0,7 ; -6 ; -0,2 ; -6,6 ; -6,4 ; 1,1 ; -0,55 ; NABEURDE2189 ; D9e9FD3bA280a8Dd0bB95Fe0f05FaBFdA7abbFFb5ffdAAea8f103ecE2eEE78eC ; < DfeBeS81E21W5yn254eb8gYprE20i4T1MfUqTa057f2NQ675lH7Ljig651a0EM3r > >										18
513 //	        < 19 ; 36M ; JAN 2021 ; opt. ; - ; 0 ; 1,0401651925952 ; -1 ; -0,00025 ; 0,00025 ; -8,9 ; 4,6 ; 6,6 ; 8,4 ; 9,9 ; -2,5 ; -0,67 ; NABEURJA2173 ; b02AFdeefB6f77BfaEfBb71ebFFfffB7bfd0a9f30b6b9Cce78Dd00aAfcEBce79 ; < Q86Hg9XX45JeiVng3NUzjhkpibSMok88Sw6Qk1u03672778af0QLtL34mtXtY69O > >										19
514 //	        < 20 ; 38M ; MAR 2021 ; opt. ; - ; 0 ; 1,04460164060659 ; -1 ; -0,00025 ; 0,00025 ; 9,3 ; 5,9 ; 3,3 ; -5 ; 8,2 ; -5,5 ; -0,25 ; NABEURMA2182 ; dbb48caFae7cD5Fb2b1fEafc19aDdBfaeea9Dc324cea8EFC8d395A824f3DBad6 ; < rcXO3b06fE3bg0cnPWy3EDNYrs418LBSBp2Lf4vpvQ5jIBBc3pKHK1526CrO0biB > >										20
515 //	        < 21 ; 40M ; MAY 2021 ; opt. ; - ; 0 ; 1,04924082169297 ; -1 ; -0,00025 ; 0,00025 ; 2,4 ; -6,8 ; -2 ; 1,6 ; 3,5 ; 5,1 ; -0,21 ; NABEURMA2171 ; EbDf1604c1A4EaBC9fe6ecAFdCEE4deFBfEEea9BFEf5ec4FeD96Bc70c8dD5a58 ; < 5reS9QDU2Jt1TLzEz25nUf4pS91q5mDJe334VhpwHJ6GMeZ1q2a82nZCX21OZb69 > >										21
516 //	        < 22 ; 42M ; JUL 2021 ; opt. ; - ; 0 ; 1,05396671459775 ; -1 ; -0,00025 ; 0,00025 ; 9,1 ; 4,9 ; -7,3 ; -0,3 ; -2,8 ; 7,9 ; -0,97 ; NABEURJU2115 ; b734B8eDa418DE267bfa010E466dfe3c994BC3b5C890E21dc26b7e1a9cD7B83a ; < 5q1Gf021EhEX5K4P9hXmUOFXRkiDBxeJi2ApCpKoW94u2RJG4BI7Kk0B4r9KUVLQ > >										22
517 //	        < 23 ; 44M ; SEP 2021 ; opt. ; - ; 0 ; 1,05907861835916 ; -1 ; -0,00025 ; 0,00025 ; -2,2 ; -7,6 ; 3,7 ; 0,5 ; -4 ; -1,1 ; 0,62 ; NABEURSE2178 ; 917dAaAb2ABADFCF8fcddeE7AA9Eed37f07f5159adDb093BeFC8e4e8e60BeEaB ; < 1D833wPG6Tp5Ufoj8xfx617969Mx5mmt80YOqi6V7523t8DxvmC920t42e8iqm5v > >										23
518 //	        < 24 ; 47M ; DEC 2021 ; opt. ; - ; 0 ; 1,0643160268966 ; -1 ; -0,00025 ; 0,00025 ; -9,2 ; -2,4 ; -0,2 ; 2 ; 1 ; -4,9 ; -0,07 ; NABEURDE2157 ; e82cf2220271bE9dd5D66fCfd329FFc1B9F0fDEcE3faBE8C9eDCE2BeE2cA2C1a ; < z40RCxvgSGy147H2c8dHcfNLh821rBvn6a8lEReP547loOWX3e15xL5D5R850KvN > >										24
519 											
520 //	  < CALLS ; 3M ; Strike ; Symbol ; Last ; T(-1) ; Change ; Volume ; BAS_1 ; BAS_2 ; o.i. @ eth_hex ; @ btc_882 >										
521 											
522 //	#DIV/0 !										1
523 //	#DIV/0 !										2
524 //	#DIV/0 !										3
525 //	#DIV/0 !										4
526 //	#DIV/0 !										5
527 //	#DIV/0 !										6
528 //	#DIV/0 !										7
529 //	#DIV/0 !										8
530 //	#DIV/0 !										9
531 //	#DIV/0 !										10
532 //	#DIV/0 !										11
533 //	#DIV/0 !										12
534 //	#DIV/0 !										13
535 //	#DIV/0 !										14
536 //	#DIV/0 !										15
537 //	#DIV/0 !										16
538 //	#DIV/0 !										17
539 //	#DIV/0 !										18
540 //	#DIV/0 !										19
541 //	#DIV/0 !										20
542 //	#DIV/0 !										21
543 //											
544 //	  < PUTS ; 3M ; Strike ; Symbol ; Last ; T(-1) ; Change ; Volume ; BAS_1 ; BAS_2 ; o.i. @ eth_hex ; @ btc_882 >										
545 //											
546 //	#DIV/0 !										1
547 //	#DIV/0 !										2
548 //	#DIV/0 !										3
549 //	#DIV/0 !										4
550 //	#DIV/0 !										5
551 //	#DIV/0 !										6
552 //	#DIV/0 !										7
553 //	#DIV/0 !										8
554 //	#DIV/0 !										9
555 //	#DIV/0 !										10
556 //	#DIV/0 !										11
557 //	#DIV/0 !										12
558 //	#DIV/0 !										13
559 //	#DIV/0 !										14
560 //	#DIV/0 !										15
561 //	#DIV/0 !										16
562 //	#DIV/0 !										17
563 //	#DIV/0 !										18
564 //	#DIV/0 !										19
565 //	#DIV/0 !										20
566 //	#DIV/0 !										21
567 											
568 											
569 											
570 											
571 											
572 //	NABEUR										
573 											
574 //	  < # ; REF ; Month ; Optionchain ; Chart ; Last ; T(-1) ; Change ; BAS_1 ; BAS_2 ; Prior. Settle ; Open ; High ; Low ; Volume ; Hi / Lo ; Updated (s) ; Code ; @ eth_hex ; @ btc_882 >										
575 											
576 //	        < 0 ; T0 ; - ; - ; - ; 0 ; 1 ; -1 ; - ; - ; - ; - ; - ; - ; - ; - ; - ; - ; f4AddAd7aaAc515DCFAD905Cc3Efa08cfEae8EF5Ae1F63Dfe7bcDcf23bf77ADA ; < to6Od76JFlu03IYs1nj527h6uJlLLYTm5282x757SG997ww449E1a0tZHpw467da > >										0
577 //	        < 1 ; 0M ; JAN 2019 ; opt. ; - ; 0 ; 1,00026609499864 ; -1 ; -0,00025 ; 0,00025 ; -6 ; -0,2 ; 1,6 ; -5,3 ; -3,6 ; 6,5 ; -0,06 ; NABEUR26JA19 ; f2C9dDE6b26A4bADEe4cc9Ef2FedAbEDabEa2BDBBFB21Fdd3C0f0edBFDca2Bb6 ; < 92J4ya37SZ0k76941BELR494r7qJeZg8C18qkS6mWlQ8bA5JwIH780AjpGZvxEtr > >										1
578 //	        < 2 ; 2M ; MAR 2019 ; opt. ; - ; 0 ; 1,00074045449057 ; -1 ; -0,00025 ; 0,00025 ; 2,5 ; 3,6 ; 6,8 ; -8,6 ; -3,6 ; -7,6 ; 0,53 ; NABEURMA1936 ; 76CADAa0dCAD4f9e28BC74fE36eeFBEfE0c9CACE2b9776e55b0FBF5Ae847c9e6 ; < aDwt79SowQO5Jght4jMa4q9HbJ4Dxg3sCHyK6E5K38KNkMxxUw4RYF1B9J4eQ8LM > >										2
579 //	        < 3 ; 4M ; MAY 2019 ; opt. ; - ; 0 ; 1,00137633990192 ; -1 ; -0,00025 ; 0,00025 ; 9,4 ; 7,9 ; 9,5 ; -8,5 ; -0,4 ; -7,6 ; 0,86 ; NABEURMA1934 ; 7fdCCd9bCcFdFA6cDA36ACD1EBFC173C70Fb9BfE9BBe952efbAADfb890622c2a ; < jO618x9ekJ1Lv1XC0A6q53yEWscZpiC7RB7da97L32bR5r6aIPm75DW7CWFBYA06 > >										3
580 //	        < 4 ; 6M ; JUL 2019 ; opt. ; - ; 0 ; 1,002286230351 ; -1 ; -0,00025 ; 0,00025 ; 7,4 ; 4,8 ; 7,4 ; 5,6 ; 9 ; -8,7 ; 0,63 ; NABEURJU1956 ; adeb1be4CaC7CEC2FF6B8Def4B04EdAebEa0ab08Ee40F632ceEDad3Ae3770C7f ; < h9KiF3XQO1ce6oS1qkKn5dfEBRA2YR35c1P159gH27JPFu8i0HHQP8q3P1ZZ23eq > >										4
581 //	        < 5 ; 8M ; SEP 2019 ; opt. ; - ; 0 ; 1,00336860738833 ; -1 ; -0,00025 ; 0,00025 ; 7 ; -8,3 ; 0,7 ; -1,5 ; 4,5 ; -8,1 ; -0,59 ; NABEURSE1946 ; CaE2261bbaf5cBECBFdCfB4Ad2Ea2473fFd8BC7bD0f8F73dFACccECC1DBDc6af ; < zsRU1zArGtZiy309z3k2C00WdGVErZ7O1t9W7FO7r3BOP9E620ldq9GP588bB5I8 > >										5
582 //	        < 6 ; 11M ; DEC 2019 ; opt. ; - ; 0 ; 1,00464410935353 ; -1 ; -0,00025 ; 0,00025 ; 5,4 ; -8 ; 7,6 ; -1 ; 4,6 ; 1,2 ; -0,37 ; NABEURDE1943 ; 3D9e234BA02FAcb1DaF3CaBCFE91361BD1afdC9eD42abc453C4b2fAACd8409E0 ; < gpAZ47OvET1pRg0pQD87yqF84pUinmn5pVX73kshaPTMK3JqV54qC2Kaz9Q1cWwk > >										6
583 //	        < 7 ; 12M ; JAN 2020 ; opt. ; - ; 0 ; 1,00601301197941 ; -1 ; -0,00025 ; 0,00025 ; -8 ; -9,1 ; -9,1 ; 2,3 ; 7 ; -9,7 ; 0,13 ; NABEURJA2055 ; daacACddFE3abFf12fafdcA7eDbE4aD49fDd4303a6b6bF2fAa8F356EDA38bfA4 ; < OlTW7ZyeVHBImUL1ezKLrK2q52204WYB2JSG010aD0q96AGc71pbJT4LknHOVU3t > >										7
584 //	        < 8 ; 14M ; MAR 2020 ; opt. ; - ; 0 ; 1,00770107464382 ; -1 ; -0,00025 ; 0,00025 ; 7,3 ; -4 ; -5,2 ; 9,8 ; -5 ; -3,8 ; -0,64 ; NABEURMA2056 ; 1AEbCbe8FdB51bFd1fA455eFcBAB42FdFCffEebb0eF2fAC8BC554Ab08d0Eed1A ; < J50jNaOyxAQ1Omzu54ljn1NWB5XwUfw4XRf8MPavU6ux411J3t8o2xTg2dfYe3GP > >										8
585 //	        < 9 ; 16M ; MAY 2020 ; opt. ; - ; 0 ; 1,00951031593822 ; -1 ; -0,00025 ; 0,00025 ; -7,1 ; -6,6 ; 0,3 ; 3,6 ; 6,2 ; 3,2 ; 0,96 ; NABEURMA2075 ; FbdFB31EDa92e4ACfa6BddcFFdAbbDe5AEBAefF333Cb8BaDaebAd1afaCA1Bdef ; < C4T3SI0er22kd1B9Y2xZ278uMS9ODlZ1ZM5219wwxtKO2OfmW013g2ww084GE67H > >										9
586 //	        < 10 ; 18M ; JUL 2020 ; opt. ; - ; 0 ; 1,01152216877121 ; -1 ; -0,00025 ; 0,00025 ; -6,6 ; 9,2 ; -0,7 ; 9,9 ; -9,4 ; -2,6 ; -0,7 ; NABEURJU2059 ; A0fac1445fdb0efdAd67F5Ecb1ddfaCa4a5d8e6feaF607FbAd6DfDdaA8f3ec83 ; < 9t2I3N9CkAxA1waJ8ab1ELsq0mf89UK09bju9P9f6K61644nS7N6N4iwsVmgmD3k > >										10
587 //	        < 11 ; 20M ; SEP 2020 ; opt. ; - ; 0 ; 1,01378335391844 ; -1 ; -0,00025 ; 0,00025 ; -3 ; 5,2 ; 7 ; -4,3 ; 3,6 ; 1,8 ; -0,59 ; NABEURSE2053 ; EaEdBEAe86B8cB9C2a751ffdfFdf3Ce5EAf5D43eFBc41BfB3CFbCc8ecbbfeFbc ; < 6w6EFb938Y06481OxD1H2XU04EW50N34ure7877Jld7KRIo4SeiJLHZMO61fP06B > >										11
588 //	        < 12 ; 23M ; DEC 2020 ; opt. ; - ; 0 ; 1,0162438061184 ; -1 ; -0,00025 ; 0,00025 ; -7,7 ; -5,3 ; -4,3 ; 5,5 ; -5,5 ; -2,8 ; -0,75 ; NABEURDE2057 ; DbEaec74bf0cbB8CF2A6E8b0C1dE278c8B1fE1bf5bFcFeFdB1E2D8a97feDd8ee ; < no7gRb56drzRvI6b0a6Z96j3ztslj3j91kB539IP85Eut44t8ojq3Ybm8p0993FW > >										12
589 //	        < 13 ; 24M ; JAN 2021 ; opt. ; - ; 0 ; 1,01890292514512 ; -1 ; -0,00025 ; 0,00025 ; -2,5 ; -8,7 ; -2,6 ; -8,1 ; 3,3 ; 0 ; -0,2 ; NABEURJA2184 ; e8a1C0Fb1cB82AFecfAeF633ce61C4fF27dd1dbA9a6a7BCCe0EDacb9BBf9fCC9 ; < yrSx9HtjYOKzdDaGEWkgozy66NT58969kek0S4zf2M1107g3QD1cgc7hC6AU6pQY > >										13
590 //	        < 14 ; 26M ; MAR 2021 ; opt. ; - ; 0 ; 1,02188145745659 ; -1 ; -0,00025 ; 0,00025 ; 4,9 ; -1,2 ; 0,8 ; 7,5 ; -9,7 ; -7 ; 0,25 ; NABEURMA2199 ; eed7645f2aEFB2dDA36E6db1bdAcD7e1a3e02F1c9909Ad58f19771d8faBa9bB7 ; < 8p38h80WchAdR6NnkqZ3zt7yzBG154moJMa4X2RA7ST6HE5P2OfNO3gVOX2F7y1a > >										14
591 //	        < 15 ; 28M ; MAY 2021 ; opt. ; - ; 0 ; 1,02507276867486 ; -1 ; -0,00025 ; 0,00025 ; -8,3 ; -2,8 ; -7,8 ; 2,9 ; 0,8 ; -9,8 ; 0,87 ; NABEURMA2196 ; A70eE4aa2c95BDFc8c6a3b2A65c8E0f8AEafaab8aFecdCdE1bFf4Ce3f2e4fDCA ; < 1X5SWJzdl11a96EYU91pO1QrGgGY3kP71T02a13XHhm7t21Y8B86Q5266x4w336K > >										15
592 //	        < 16 ; 30M ; JUL 2021 ; opt. ; - ; 0 ; 1,02853312880934 ; -1 ; -0,00025 ; 0,00025 ; -4,4 ; -9,2 ; -7,9 ; 1,8 ; 9,6 ; -6,9 ; -0,73 ; NABEURJU2190 ; fACf6b8d0efa5B1dcD50e8Fd7EcEf1F7BdBeBcca6cef79DbbD422b83DFBF6698 ; < 6PrBR9h1YW7g9Yqe7O057q7eT0vYzVo60H2GIzTs7gqq82r0JnqP9t6wD2shDNxF > >										16
593 //	        < 17 ; 32M ; SEP 2021 ; opt. ; - ; 0 ; 1,03216540423907 ; -1 ; -0,00025 ; 0,00025 ; 6,1 ; -9 ; -2,8 ; 2,8 ; -9,6 ; -7 ; 0,56 ; NABEURSE2158 ; AdDfB4A3dddce7dBfdE8bA8Ce4E07f9fF63CaAFEcDCE76FbecA7B88eE0a7bFB4 ; < 456vbWlP96q6h6MPmEBLLWUKnb02lVUJVwwZOB8f8z56UTquQ6E1U6pUy41sg2nt > >										17
594 //	        < 18 ; 35M ; DEC 2021 ; opt. ; - ; 0 ; 1,03597754487675 ; -1 ; -0,00025 ; 0,00025 ; 0,7 ; -6 ; -0,2 ; -6,6 ; -6,4 ; 1,1 ; -0,55 ; NABEURDE2189 ; D9e9FD3bA280a8Dd0bB95Fe0f05FaBFdA7abbFFb5ffdAAea8f103ecE2eEE78eC ; < DfeBeS81E21W5yn254eb8gYprE20i4T1MfUqTa057f2NQ675lH7Ljig651a0EM3r > >										18
595 //	        < 19 ; 36M ; JAN 2021 ; opt. ; - ; 0 ; 1,0401651925952 ; -1 ; -0,00025 ; 0,00025 ; -8,9 ; 4,6 ; 6,6 ; 8,4 ; 9,9 ; -2,5 ; -0,67 ; NABEURJA2173 ; b02AFdeefB6f77BfaEfBb71ebFFfffB7bfd0a9f30b6b9Cce78Dd00aAfcEBce79 ; < Q86Hg9XX45JeiVng3NUzjhkpibSMok88Sw6Qk1u03672778af0QLtL34mtXtY69O > >										19
596 //	        < 20 ; 38M ; MAR 2021 ; opt. ; - ; 0 ; 1,04460164060659 ; -1 ; -0,00025 ; 0,00025 ; 9,3 ; 5,9 ; 3,3 ; -5 ; 8,2 ; -5,5 ; -0,25 ; NABEURMA2182 ; dbb48caFae7cD5Fb2b1fEafc19aDdBfaeea9Dc324cea8EFC8d395A824f3DBad6 ; < rcXO3b06fE3bg0cnPWy3EDNYrs418LBSBp2Lf4vpvQ5jIBBc3pKHK1526CrO0biB > >										20
597 //	        < 21 ; 40M ; MAY 2021 ; opt. ; - ; 0 ; 1,04924082169297 ; -1 ; -0,00025 ; 0,00025 ; 2,4 ; -6,8 ; -2 ; 1,6 ; 3,5 ; 5,1 ; -0,21 ; NABEURMA2171 ; EbDf1604c1A4EaBC9fe6ecAFdCEE4deFBfEEea9BFEf5ec4FeD96Bc70c8dD5a58 ; < 5reS9QDU2Jt1TLzEz25nUf4pS91q5mDJe334VhpwHJ6GMeZ1q2a82nZCX21OZb69 > >										21
598 //	        < 22 ; 42M ; JUL 2021 ; opt. ; - ; 0 ; 1,05396671459775 ; -1 ; -0,00025 ; 0,00025 ; 9,1 ; 4,9 ; -7,3 ; -0,3 ; -2,8 ; 7,9 ; -0,97 ; NABEURJU2115 ; b734B8eDa418DE267bfa010E466dfe3c994BC3b5C890E21dc26b7e1a9cD7B83a ; < 5q1Gf021EhEX5K4P9hXmUOFXRkiDBxeJi2ApCpKoW94u2RJG4BI7Kk0B4r9KUVLQ > >										22
599 //	        < 23 ; 44M ; SEP 2021 ; opt. ; - ; 0 ; 1,05907861835916 ; -1 ; -0,00025 ; 0,00025 ; -2,2 ; -7,6 ; 3,7 ; 0,5 ; -4 ; -1,1 ; 0,62 ; NABEURSE2178 ; 917dAaAb2ABADFCF8fcddeE7AA9Eed37f07f5159adDb093BeFC8e4e8e60BeEaB ; < 1D833wPG6Tp5Ufoj8xfx617969Mx5mmt80YOqi6V7523t8DxvmC920t42e8iqm5v > >										23
600 //	        < 24 ; 47M ; DEC 2021 ; opt. ; - ; 0 ; 1,0643160268966 ; -1 ; -0,00025 ; 0,00025 ; -9,2 ; -2,4 ; -0,2 ; 2 ; 1 ; -4,9 ; -0,07 ; NABEURDE2157 ; e82cf2220271bE9dd5D66fCfd329FFc1B9F0fDEcE3faBE8C9eDCE2BeE2cA2C1a ; < z40RCxvgSGy147H2c8dHcfNLh821rBvn6a8lEReP547loOWX3e15xL5D5R850KvN > >										24
601 											
602 //	  < CALLS ; 6M ; Strike ; Symbol ; Last ; T(-1) ; Change ; Volume ; BAS_1 ; BAS_2 ; o.i. @ eth_hex ; @ btc_882 >										
603 											
604 //	#DIV/0 !										1
605 //	#DIV/0 !										2
606 //	#DIV/0 !										3
607 //	#DIV/0 !										4
608 //	#DIV/0 !										5
609 //	#DIV/0 !										6
610 //	#DIV/0 !										7
611 //	#DIV/0 !										8
612 //	#DIV/0 !										9
613 //	#DIV/0 !										10
614 //	#DIV/0 !										11
615 //	#DIV/0 !										12
616 //	#DIV/0 !										13
617 //	#DIV/0 !										14
618 //	#DIV/0 !										15
619 //	#DIV/0 !										16
620 //	#DIV/0 !										17
621 //	#DIV/0 !										18
622 //	#DIV/0 !										19
623 //	#DIV/0 !										20
624 //	#DIV/0 !										21
625 //											
626 //	  < PUTS ; 6M ; Strike ; Symbol ; Last ; T(-1) ; Change ; Volume ; BAS_1 ; BAS_2 ; o.i. @ eth_hex ; @ btc_882 >										
627 //											
628 //	#DIV/0 !										1
629 //	#DIV/0 !										2
630 //	#DIV/0 !										3
631 //	#DIV/0 !										4
632 //	#DIV/0 !										5
633 //	#DIV/0 !										6
634 //	#DIV/0 !										7
635 //	#DIV/0 !										8
636 //	#DIV/0 !										9
637 //	#DIV/0 !										10
638 //	#DIV/0 !										11
639 //	#DIV/0 !										12
640 //	#DIV/0 !										13
641 //	#DIV/0 !										14
642 //	#DIV/0 !										15
643 //	#DIV/0 !										16
644 //	#DIV/0 !										17
645 //	#DIV/0 !										18
646 //	#DIV/0 !										19
647 //	#DIV/0 !										20
648 //	#DIV/0 !										21
649 											
650 											
651 											
652 											
653 											
654 //	NABEUR										
655 											
656 //	  < # ; REF ; Month ; Optionchain ; Chart ; Last ; T(-1) ; Change ; BAS_1 ; BAS_2 ; Prior. Settle ; Open ; High ; Low ; Volume ; Hi / Lo ; Updated (s) ; Code ; @ eth_hex ; @ btc_882 >										
657 											
658 //	        < 0 ; T0 ; - ; - ; - ; 0 ; 1 ; -1 ; - ; - ; - ; - ; - ; - ; - ; - ; - ; - ; f4AddAd7aaAc515DCFAD905Cc3Efa08cfEae8EF5Ae1F63Dfe7bcDcf23bf77ADA ; < to6Od76JFlu03IYs1nj527h6uJlLLYTm5282x757SG997ww449E1a0tZHpw467da > >										0
659 //	        < 1 ; 0M ; JAN 2019 ; opt. ; - ; 0 ; 1,00026609499864 ; -1 ; -0,00025 ; 0,00025 ; -6 ; -0,2 ; 1,6 ; -5,3 ; -3,6 ; 6,5 ; -0,06 ; NABEUR26JA19 ; f2C9dDE6b26A4bADEe4cc9Ef2FedAbEDabEa2BDBBFB21Fdd3C0f0edBFDca2Bb6 ; < 92J4ya37SZ0k76941BELR494r7qJeZg8C18qkS6mWlQ8bA5JwIH780AjpGZvxEtr > >										1
660 //	        < 2 ; 2M ; MAR 2019 ; opt. ; - ; 0 ; 1,00074045449057 ; -1 ; -0,00025 ; 0,00025 ; 2,5 ; 3,6 ; 6,8 ; -8,6 ; -3,6 ; -7,6 ; 0,53 ; NABEURMA1936 ; 76CADAa0dCAD4f9e28BC74fE36eeFBEfE0c9CACE2b9776e55b0FBF5Ae847c9e6 ; < aDwt79SowQO5Jght4jMa4q9HbJ4Dxg3sCHyK6E5K38KNkMxxUw4RYF1B9J4eQ8LM > >										2
661 //	        < 3 ; 4M ; MAY 2019 ; opt. ; - ; 0 ; 1,00137633990192 ; -1 ; -0,00025 ; 0,00025 ; 9,4 ; 7,9 ; 9,5 ; -8,5 ; -0,4 ; -7,6 ; 0,86 ; NABEURMA1934 ; 7fdCCd9bCcFdFA6cDA36ACD1EBFC173C70Fb9BfE9BBe952efbAADfb890622c2a ; < jO618x9ekJ1Lv1XC0A6q53yEWscZpiC7RB7da97L32bR5r6aIPm75DW7CWFBYA06 > >										3
662 //	        < 4 ; 6M ; JUL 2019 ; opt. ; - ; 0 ; 1,002286230351 ; -1 ; -0,00025 ; 0,00025 ; 7,4 ; 4,8 ; 7,4 ; 5,6 ; 9 ; -8,7 ; 0,63 ; NABEURJU1956 ; adeb1be4CaC7CEC2FF6B8Def4B04EdAebEa0ab08Ee40F632ceEDad3Ae3770C7f ; < h9KiF3XQO1ce6oS1qkKn5dfEBRA2YR35c1P159gH27JPFu8i0HHQP8q3P1ZZ23eq > >										4
663 //	        < 5 ; 8M ; SEP 2019 ; opt. ; - ; 0 ; 1,00336860738833 ; -1 ; -0,00025 ; 0,00025 ; 7 ; -8,3 ; 0,7 ; -1,5 ; 4,5 ; -8,1 ; -0,59 ; NABEURSE1946 ; CaE2261bbaf5cBECBFdCfB4Ad2Ea2473fFd8BC7bD0f8F73dFACccECC1DBDc6af ; < zsRU1zArGtZiy309z3k2C00WdGVErZ7O1t9W7FO7r3BOP9E620ldq9GP588bB5I8 > >										5
664 //	        < 6 ; 11M ; DEC 2019 ; opt. ; - ; 0 ; 1,00464410935353 ; -1 ; -0,00025 ; 0,00025 ; 5,4 ; -8 ; 7,6 ; -1 ; 4,6 ; 1,2 ; -0,37 ; NABEURDE1943 ; 3D9e234BA02FAcb1DaF3CaBCFE91361BD1afdC9eD42abc453C4b2fAACd8409E0 ; < gpAZ47OvET1pRg0pQD87yqF84pUinmn5pVX73kshaPTMK3JqV54qC2Kaz9Q1cWwk > >										6
665 //	        < 7 ; 12M ; JAN 2020 ; opt. ; - ; 0 ; 1,00601301197941 ; -1 ; -0,00025 ; 0,00025 ; -8 ; -9,1 ; -9,1 ; 2,3 ; 7 ; -9,7 ; 0,13 ; NABEURJA2055 ; daacACddFE3abFf12fafdcA7eDbE4aD49fDd4303a6b6bF2fAa8F356EDA38bfA4 ; < OlTW7ZyeVHBImUL1ezKLrK2q52204WYB2JSG010aD0q96AGc71pbJT4LknHOVU3t > >										7
666 //	        < 8 ; 14M ; MAR 2020 ; opt. ; - ; 0 ; 1,00770107464382 ; -1 ; -0,00025 ; 0,00025 ; 7,3 ; -4 ; -5,2 ; 9,8 ; -5 ; -3,8 ; -0,64 ; NABEURMA2056 ; 1AEbCbe8FdB51bFd1fA455eFcBAB42FdFCffEebb0eF2fAC8BC554Ab08d0Eed1A ; < J50jNaOyxAQ1Omzu54ljn1NWB5XwUfw4XRf8MPavU6ux411J3t8o2xTg2dfYe3GP > >										8
667 //	        < 9 ; 16M ; MAY 2020 ; opt. ; - ; 0 ; 1,00951031593822 ; -1 ; -0,00025 ; 0,00025 ; -7,1 ; -6,6 ; 0,3 ; 3,6 ; 6,2 ; 3,2 ; 0,96 ; NABEURMA2075 ; FbdFB31EDa92e4ACfa6BddcFFdAbbDe5AEBAefF333Cb8BaDaebAd1afaCA1Bdef ; < C4T3SI0er22kd1B9Y2xZ278uMS9ODlZ1ZM5219wwxtKO2OfmW013g2ww084GE67H > >										9
668 //	        < 10 ; 18M ; JUL 2020 ; opt. ; - ; 0 ; 1,01152216877121 ; -1 ; -0,00025 ; 0,00025 ; -6,6 ; 9,2 ; -0,7 ; 9,9 ; -9,4 ; -2,6 ; -0,7 ; NABEURJU2059 ; A0fac1445fdb0efdAd67F5Ecb1ddfaCa4a5d8e6feaF607FbAd6DfDdaA8f3ec83 ; < 9t2I3N9CkAxA1waJ8ab1ELsq0mf89UK09bju9P9f6K61644nS7N6N4iwsVmgmD3k > >										10
669 //	        < 11 ; 20M ; SEP 2020 ; opt. ; - ; 0 ; 1,01378335391844 ; -1 ; -0,00025 ; 0,00025 ; -3 ; 5,2 ; 7 ; -4,3 ; 3,6 ; 1,8 ; -0,59 ; NABEURSE2053 ; EaEdBEAe86B8cB9C2a751ffdfFdf3Ce5EAf5D43eFBc41BfB3CFbCc8ecbbfeFbc ; < 6w6EFb938Y06481OxD1H2XU04EW50N34ure7877Jld7KRIo4SeiJLHZMO61fP06B > >										11
670 //	        < 12 ; 23M ; DEC 2020 ; opt. ; - ; 0 ; 1,0162438061184 ; -1 ; -0,00025 ; 0,00025 ; -7,7 ; -5,3 ; -4,3 ; 5,5 ; -5,5 ; -2,8 ; -0,75 ; NABEURDE2057 ; DbEaec74bf0cbB8CF2A6E8b0C1dE278c8B1fE1bf5bFcFeFdB1E2D8a97feDd8ee ; < no7gRb56drzRvI6b0a6Z96j3ztslj3j91kB539IP85Eut44t8ojq3Ybm8p0993FW > >										12
671 //	        < 13 ; 24M ; JAN 2021 ; opt. ; - ; 0 ; 1,01890292514512 ; -1 ; -0,00025 ; 0,00025 ; -2,5 ; -8,7 ; -2,6 ; -8,1 ; 3,3 ; 0 ; -0,2 ; NABEURJA2184 ; e8a1C0Fb1cB82AFecfAeF633ce61C4fF27dd1dbA9a6a7BCCe0EDacb9BBf9fCC9 ; < yrSx9HtjYOKzdDaGEWkgozy66NT58969kek0S4zf2M1107g3QD1cgc7hC6AU6pQY > >										13
672 //	        < 14 ; 26M ; MAR 2021 ; opt. ; - ; 0 ; 1,02188145745659 ; -1 ; -0,00025 ; 0,00025 ; 4,9 ; -1,2 ; 0,8 ; 7,5 ; -9,7 ; -7 ; 0,25 ; NABEURMA2199 ; eed7645f2aEFB2dDA36E6db1bdAcD7e1a3e02F1c9909Ad58f19771d8faBa9bB7 ; < 8p38h80WchAdR6NnkqZ3zt7yzBG154moJMa4X2RA7ST6HE5P2OfNO3gVOX2F7y1a > >										14
673 //	        < 15 ; 28M ; MAY 2021 ; opt. ; - ; 0 ; 1,02507276867486 ; -1 ; -0,00025 ; 0,00025 ; -8,3 ; -2,8 ; -7,8 ; 2,9 ; 0,8 ; -9,8 ; 0,87 ; NABEURMA2196 ; A70eE4aa2c95BDFc8c6a3b2A65c8E0f8AEafaab8aFecdCdE1bFf4Ce3f2e4fDCA ; < 1X5SWJzdl11a96EYU91pO1QrGgGY3kP71T02a13XHhm7t21Y8B86Q5266x4w336K > >										15
674 //	        < 16 ; 30M ; JUL 2021 ; opt. ; - ; 0 ; 1,02853312880934 ; -1 ; -0,00025 ; 0,00025 ; -4,4 ; -9,2 ; -7,9 ; 1,8 ; 9,6 ; -6,9 ; -0,73 ; NABEURJU2190 ; fACf6b8d0efa5B1dcD50e8Fd7EcEf1F7BdBeBcca6cef79DbbD422b83DFBF6698 ; < 6PrBR9h1YW7g9Yqe7O057q7eT0vYzVo60H2GIzTs7gqq82r0JnqP9t6wD2shDNxF > >										16
675 //	        < 17 ; 32M ; SEP 2021 ; opt. ; - ; 0 ; 1,03216540423907 ; -1 ; -0,00025 ; 0,00025 ; 6,1 ; -9 ; -2,8 ; 2,8 ; -9,6 ; -7 ; 0,56 ; NABEURSE2158 ; AdDfB4A3dddce7dBfdE8bA8Ce4E07f9fF63CaAFEcDCE76FbecA7B88eE0a7bFB4 ; < 456vbWlP96q6h6MPmEBLLWUKnb02lVUJVwwZOB8f8z56UTquQ6E1U6pUy41sg2nt > >										17
676 //	        < 18 ; 35M ; DEC 2021 ; opt. ; - ; 0 ; 1,03597754487675 ; -1 ; -0,00025 ; 0,00025 ; 0,7 ; -6 ; -0,2 ; -6,6 ; -6,4 ; 1,1 ; -0,55 ; NABEURDE2189 ; D9e9FD3bA280a8Dd0bB95Fe0f05FaBFdA7abbFFb5ffdAAea8f103ecE2eEE78eC ; < DfeBeS81E21W5yn254eb8gYprE20i4T1MfUqTa057f2NQ675lH7Ljig651a0EM3r > >										18
677 //	        < 19 ; 36M ; JAN 2021 ; opt. ; - ; 0 ; 1,0401651925952 ; -1 ; -0,00025 ; 0,00025 ; -8,9 ; 4,6 ; 6,6 ; 8,4 ; 9,9 ; -2,5 ; -0,67 ; NABEURJA2173 ; b02AFdeefB6f77BfaEfBb71ebFFfffB7bfd0a9f30b6b9Cce78Dd00aAfcEBce79 ; < Q86Hg9XX45JeiVng3NUzjhkpibSMok88Sw6Qk1u03672778af0QLtL34mtXtY69O > >										19
678 //	        < 20 ; 38M ; MAR 2021 ; opt. ; - ; 0 ; 1,04460164060659 ; -1 ; -0,00025 ; 0,00025 ; 9,3 ; 5,9 ; 3,3 ; -5 ; 8,2 ; -5,5 ; -0,25 ; NABEURMA2182 ; dbb48caFae7cD5Fb2b1fEafc19aDdBfaeea9Dc324cea8EFC8d395A824f3DBad6 ; < rcXO3b06fE3bg0cnPWy3EDNYrs418LBSBp2Lf4vpvQ5jIBBc3pKHK1526CrO0biB > >										20
679 //	        < 21 ; 40M ; MAY 2021 ; opt. ; - ; 0 ; 1,04924082169297 ; -1 ; -0,00025 ; 0,00025 ; 2,4 ; -6,8 ; -2 ; 1,6 ; 3,5 ; 5,1 ; -0,21 ; NABEURMA2171 ; EbDf1604c1A4EaBC9fe6ecAFdCEE4deFBfEEea9BFEf5ec4FeD96Bc70c8dD5a58 ; < 5reS9QDU2Jt1TLzEz25nUf4pS91q5mDJe334VhpwHJ6GMeZ1q2a82nZCX21OZb69 > >										21
680 //	        < 22 ; 42M ; JUL 2021 ; opt. ; - ; 0 ; 1,05396671459775 ; -1 ; -0,00025 ; 0,00025 ; 9,1 ; 4,9 ; -7,3 ; -0,3 ; -2,8 ; 7,9 ; -0,97 ; NABEURJU2115 ; b734B8eDa418DE267bfa010E466dfe3c994BC3b5C890E21dc26b7e1a9cD7B83a ; < 5q1Gf021EhEX5K4P9hXmUOFXRkiDBxeJi2ApCpKoW94u2RJG4BI7Kk0B4r9KUVLQ > >										22
681 //	        < 23 ; 44M ; SEP 2021 ; opt. ; - ; 0 ; 1,05907861835916 ; -1 ; -0,00025 ; 0,00025 ; -2,2 ; -7,6 ; 3,7 ; 0,5 ; -4 ; -1,1 ; 0,62 ; NABEURSE2178 ; 917dAaAb2ABADFCF8fcddeE7AA9Eed37f07f5159adDb093BeFC8e4e8e60BeEaB ; < 1D833wPG6Tp5Ufoj8xfx617969Mx5mmt80YOqi6V7523t8DxvmC920t42e8iqm5v > >										23
682 //	        < 24 ; 47M ; DEC 2021 ; opt. ; - ; 0 ; 1,0643160268966 ; -1 ; -0,00025 ; 0,00025 ; -9,2 ; -2,4 ; -0,2 ; 2 ; 1 ; -4,9 ; -0,07 ; NABEURDE2157 ; e82cf2220271bE9dd5D66fCfd329FFc1B9F0fDEcE3faBE8C9eDCE2BeE2cA2C1a ; < z40RCxvgSGy147H2c8dHcfNLh821rBvn6a8lEReP547loOWX3e15xL5D5R850KvN > >										24
683 											
684 //	  < CALLS ; 12M ; Strike ; Symbol ; Last ; T(-1) ; Change ; Volume ; BAS_1 ; BAS_2 ; o.i. @ eth_hex ; @ btc_882 >										
685 											
686 //	#DIV/0 !										1
687 //	#DIV/0 !										2
688 //	#DIV/0 !										3
689 //	#DIV/0 !										4
690 //	#DIV/0 !										5
691 //	#DIV/0 !										6
692 //	#DIV/0 !										7
693 //	#DIV/0 !										8
694 //	#DIV/0 !										9
695 //	#DIV/0 !										10
696 //	#DIV/0 !										11
697 //	#DIV/0 !										12
698 //	#DIV/0 !										13
699 //	#DIV/0 !										14
700 //	#DIV/0 !										15
701 //	#DIV/0 !										16
702 //	#DIV/0 !										17
703 //	#DIV/0 !										18
704 //	#DIV/0 !										19
705 //	#DIV/0 !										20
706 //	#DIV/0 !										21
707 //											
708 //	  < PUTS ; 12M ; Strike ; Symbol ; Last ; T(-1) ; Change ; Volume ; BAS_1 ; BAS_2 ; o.i. @ eth_hex ; @ btc_882 >										
709 //											
710 //	#DIV/0 !										1
711 //	#DIV/0 !										2
712 //	#DIV/0 !										3
713 //	#DIV/0 !										4
714 //	#DIV/0 !										5
715 //	#DIV/0 !										6
716 //	#DIV/0 !										7
717 //	#DIV/0 !										8
718 //	#DIV/0 !										9
719 //	#DIV/0 !										10
720 //	#DIV/0 !										11
721 //	#DIV/0 !										12
722 //	#DIV/0 !										13
723 //	#DIV/0 !										14
724 //	#DIV/0 !										15
725 //	#DIV/0 !										16
726 //	#DIV/0 !										17
727 //	#DIV/0 !										18
728 //	#DIV/0 !										19
729 //	#DIV/0 !										20
730 //	#DIV/0 !										21
731 											
732 											
733 											
734 											
735 											
736 //	NABEUR										
737 											
738 //	  < # ; REF ; Month ; Optionchain ; Chart ; Last ; T(-1) ; Change ; BAS_1 ; BAS_2 ; Prior. Settle ; Open ; High ; Low ; Volume ; Hi / Lo ; Updated (s) ; Code ; @ eth_hex ; @ btc_882 >										
739 											
740 //	        < 0 ; T0 ; - ; - ; - ; 0 ; 1 ; -1 ; - ; - ; - ; - ; - ; - ; - ; - ; - ; - ; f4AddAd7aaAc515DCFAD905Cc3Efa08cfEae8EF5Ae1F63Dfe7bcDcf23bf77ADA ; < to6Od76JFlu03IYs1nj527h6uJlLLYTm5282x757SG997ww449E1a0tZHpw467da > >										0
741 //	        < 1 ; 0M ; JAN 2019 ; opt. ; - ; 0 ; 1,00026609499864 ; -1 ; -0,00025 ; 0,00025 ; -6 ; -0,2 ; 1,6 ; -5,3 ; -3,6 ; 6,5 ; -0,06 ; NABEUR26JA19 ; f2C9dDE6b26A4bADEe4cc9Ef2FedAbEDabEa2BDBBFB21Fdd3C0f0edBFDca2Bb6 ; < 92J4ya37SZ0k76941BELR494r7qJeZg8C18qkS6mWlQ8bA5JwIH780AjpGZvxEtr > >										1
742 //	        < 2 ; 2M ; MAR 2019 ; opt. ; - ; 0 ; 1,00074045449057 ; -1 ; -0,00025 ; 0,00025 ; 2,5 ; 3,6 ; 6,8 ; -8,6 ; -3,6 ; -7,6 ; 0,53 ; NABEURMA1936 ; 76CADAa0dCAD4f9e28BC74fE36eeFBEfE0c9CACE2b9776e55b0FBF5Ae847c9e6 ; < aDwt79SowQO5Jght4jMa4q9HbJ4Dxg3sCHyK6E5K38KNkMxxUw4RYF1B9J4eQ8LM > >										2
743 //	        < 3 ; 4M ; MAY 2019 ; opt. ; - ; 0 ; 1,00137633990192 ; -1 ; -0,00025 ; 0,00025 ; 9,4 ; 7,9 ; 9,5 ; -8,5 ; -0,4 ; -7,6 ; 0,86 ; NABEURMA1934 ; 7fdCCd9bCcFdFA6cDA36ACD1EBFC173C70Fb9BfE9BBe952efbAADfb890622c2a ; < jO618x9ekJ1Lv1XC0A6q53yEWscZpiC7RB7da97L32bR5r6aIPm75DW7CWFBYA06 > >										3
744 //	        < 4 ; 6M ; JUL 2019 ; opt. ; - ; 0 ; 1,002286230351 ; -1 ; -0,00025 ; 0,00025 ; 7,4 ; 4,8 ; 7,4 ; 5,6 ; 9 ; -8,7 ; 0,63 ; NABEURJU1956 ; adeb1be4CaC7CEC2FF6B8Def4B04EdAebEa0ab08Ee40F632ceEDad3Ae3770C7f ; < h9KiF3XQO1ce6oS1qkKn5dfEBRA2YR35c1P159gH27JPFu8i0HHQP8q3P1ZZ23eq > >										4
745 //	        < 5 ; 8M ; SEP 2019 ; opt. ; - ; 0 ; 1,00336860738833 ; -1 ; -0,00025 ; 0,00025 ; 7 ; -8,3 ; 0,7 ; -1,5 ; 4,5 ; -8,1 ; -0,59 ; NABEURSE1946 ; CaE2261bbaf5cBECBFdCfB4Ad2Ea2473fFd8BC7bD0f8F73dFACccECC1DBDc6af ; < zsRU1zArGtZiy309z3k2C00WdGVErZ7O1t9W7FO7r3BOP9E620ldq9GP588bB5I8 > >										5
746 //	        < 6 ; 11M ; DEC 2019 ; opt. ; - ; 0 ; 1,00464410935353 ; -1 ; -0,00025 ; 0,00025 ; 5,4 ; -8 ; 7,6 ; -1 ; 4,6 ; 1,2 ; -0,37 ; NABEURDE1943 ; 3D9e234BA02FAcb1DaF3CaBCFE91361BD1afdC9eD42abc453C4b2fAACd8409E0 ; < gpAZ47OvET1pRg0pQD87yqF84pUinmn5pVX73kshaPTMK3JqV54qC2Kaz9Q1cWwk > >										6
747 //	        < 7 ; 12M ; JAN 2020 ; opt. ; - ; 0 ; 1,00601301197941 ; -1 ; -0,00025 ; 0,00025 ; -8 ; -9,1 ; -9,1 ; 2,3 ; 7 ; -9,7 ; 0,13 ; NABEURJA2055 ; daacACddFE3abFf12fafdcA7eDbE4aD49fDd4303a6b6bF2fAa8F356EDA38bfA4 ; < OlTW7ZyeVHBImUL1ezKLrK2q52204WYB2JSG010aD0q96AGc71pbJT4LknHOVU3t > >										7
748 //	        < 8 ; 14M ; MAR 2020 ; opt. ; - ; 0 ; 1,00770107464382 ; -1 ; -0,00025 ; 0,00025 ; 7,3 ; -4 ; -5,2 ; 9,8 ; -5 ; -3,8 ; -0,64 ; NABEURMA2056 ; 1AEbCbe8FdB51bFd1fA455eFcBAB42FdFCffEebb0eF2fAC8BC554Ab08d0Eed1A ; < J50jNaOyxAQ1Omzu54ljn1NWB5XwUfw4XRf8MPavU6ux411J3t8o2xTg2dfYe3GP > >										8
749 //	        < 9 ; 16M ; MAY 2020 ; opt. ; - ; 0 ; 1,00951031593822 ; -1 ; -0,00025 ; 0,00025 ; -7,1 ; -6,6 ; 0,3 ; 3,6 ; 6,2 ; 3,2 ; 0,96 ; NABEURMA2075 ; FbdFB31EDa92e4ACfa6BddcFFdAbbDe5AEBAefF333Cb8BaDaebAd1afaCA1Bdef ; < C4T3SI0er22kd1B9Y2xZ278uMS9ODlZ1ZM5219wwxtKO2OfmW013g2ww084GE67H > >										9
750 //	        < 10 ; 18M ; JUL 2020 ; opt. ; - ; 0 ; 1,01152216877121 ; -1 ; -0,00025 ; 0,00025 ; -6,6 ; 9,2 ; -0,7 ; 9,9 ; -9,4 ; -2,6 ; -0,7 ; NABEURJU2059 ; A0fac1445fdb0efdAd67F5Ecb1ddfaCa4a5d8e6feaF607FbAd6DfDdaA8f3ec83 ; < 9t2I3N9CkAxA1waJ8ab1ELsq0mf89UK09bju9P9f6K61644nS7N6N4iwsVmgmD3k > >										10
751 //	        < 11 ; 20M ; SEP 2020 ; opt. ; - ; 0 ; 1,01378335391844 ; -1 ; -0,00025 ; 0,00025 ; -3 ; 5,2 ; 7 ; -4,3 ; 3,6 ; 1,8 ; -0,59 ; NABEURSE2053 ; EaEdBEAe86B8cB9C2a751ffdfFdf3Ce5EAf5D43eFBc41BfB3CFbCc8ecbbfeFbc ; < 6w6EFb938Y06481OxD1H2XU04EW50N34ure7877Jld7KRIo4SeiJLHZMO61fP06B > >										11
752 //	        < 12 ; 23M ; DEC 2020 ; opt. ; - ; 0 ; 1,0162438061184 ; -1 ; -0,00025 ; 0,00025 ; -7,7 ; -5,3 ; -4,3 ; 5,5 ; -5,5 ; -2,8 ; -0,75 ; NABEURDE2057 ; DbEaec74bf0cbB8CF2A6E8b0C1dE278c8B1fE1bf5bFcFeFdB1E2D8a97feDd8ee ; < no7gRb56drzRvI6b0a6Z96j3ztslj3j91kB539IP85Eut44t8ojq3Ybm8p0993FW > >										12
753 //	        < 13 ; 24M ; JAN 2021 ; opt. ; - ; 0 ; 1,01890292514512 ; -1 ; -0,00025 ; 0,00025 ; -2,5 ; -8,7 ; -2,6 ; -8,1 ; 3,3 ; 0 ; -0,2 ; NABEURJA2184 ; e8a1C0Fb1cB82AFecfAeF633ce61C4fF27dd1dbA9a6a7BCCe0EDacb9BBf9fCC9 ; < yrSx9HtjYOKzdDaGEWkgozy66NT58969kek0S4zf2M1107g3QD1cgc7hC6AU6pQY > >										13
754 //	        < 14 ; 26M ; MAR 2021 ; opt. ; - ; 0 ; 1,02188145745659 ; -1 ; -0,00025 ; 0,00025 ; 4,9 ; -1,2 ; 0,8 ; 7,5 ; -9,7 ; -7 ; 0,25 ; NABEURMA2199 ; eed7645f2aEFB2dDA36E6db1bdAcD7e1a3e02F1c9909Ad58f19771d8faBa9bB7 ; < 8p38h80WchAdR6NnkqZ3zt7yzBG154moJMa4X2RA7ST6HE5P2OfNO3gVOX2F7y1a > >										14
755 //	        < 15 ; 28M ; MAY 2021 ; opt. ; - ; 0 ; 1,02507276867486 ; -1 ; -0,00025 ; 0,00025 ; -8,3 ; -2,8 ; -7,8 ; 2,9 ; 0,8 ; -9,8 ; 0,87 ; NABEURMA2196 ; A70eE4aa2c95BDFc8c6a3b2A65c8E0f8AEafaab8aFecdCdE1bFf4Ce3f2e4fDCA ; < 1X5SWJzdl11a96EYU91pO1QrGgGY3kP71T02a13XHhm7t21Y8B86Q5266x4w336K > >										15
756 //	        < 16 ; 30M ; JUL 2021 ; opt. ; - ; 0 ; 1,02853312880934 ; -1 ; -0,00025 ; 0,00025 ; -4,4 ; -9,2 ; -7,9 ; 1,8 ; 9,6 ; -6,9 ; -0,73 ; NABEURJU2190 ; fACf6b8d0efa5B1dcD50e8Fd7EcEf1F7BdBeBcca6cef79DbbD422b83DFBF6698 ; < 6PrBR9h1YW7g9Yqe7O057q7eT0vYzVo60H2GIzTs7gqq82r0JnqP9t6wD2shDNxF > >										16
757 //	        < 17 ; 32M ; SEP 2021 ; opt. ; - ; 0 ; 1,03216540423907 ; -1 ; -0,00025 ; 0,00025 ; 6,1 ; -9 ; -2,8 ; 2,8 ; -9,6 ; -7 ; 0,56 ; NABEURSE2158 ; AdDfB4A3dddce7dBfdE8bA8Ce4E07f9fF63CaAFEcDCE76FbecA7B88eE0a7bFB4 ; < 456vbWlP96q6h6MPmEBLLWUKnb02lVUJVwwZOB8f8z56UTquQ6E1U6pUy41sg2nt > >										17
758 //	        < 18 ; 35M ; DEC 2021 ; opt. ; - ; 0 ; 1,03597754487675 ; -1 ; -0,00025 ; 0,00025 ; 0,7 ; -6 ; -0,2 ; -6,6 ; -6,4 ; 1,1 ; -0,55 ; NABEURDE2189 ; D9e9FD3bA280a8Dd0bB95Fe0f05FaBFdA7abbFFb5ffdAAea8f103ecE2eEE78eC ; < DfeBeS81E21W5yn254eb8gYprE20i4T1MfUqTa057f2NQ675lH7Ljig651a0EM3r > >										18
759 //	        < 19 ; 36M ; JAN 2021 ; opt. ; - ; 0 ; 1,0401651925952 ; -1 ; -0,00025 ; 0,00025 ; -8,9 ; 4,6 ; 6,6 ; 8,4 ; 9,9 ; -2,5 ; -0,67 ; NABEURJA2173 ; b02AFdeefB6f77BfaEfBb71ebFFfffB7bfd0a9f30b6b9Cce78Dd00aAfcEBce79 ; < Q86Hg9XX45JeiVng3NUzjhkpibSMok88Sw6Qk1u03672778af0QLtL34mtXtY69O > >										19
760 //	        < 20 ; 38M ; MAR 2021 ; opt. ; - ; 0 ; 1,04460164060659 ; -1 ; -0,00025 ; 0,00025 ; 9,3 ; 5,9 ; 3,3 ; -5 ; 8,2 ; -5,5 ; -0,25 ; NABEURMA2182 ; dbb48caFae7cD5Fb2b1fEafc19aDdBfaeea9Dc324cea8EFC8d395A824f3DBad6 ; < rcXO3b06fE3bg0cnPWy3EDNYrs418LBSBp2Lf4vpvQ5jIBBc3pKHK1526CrO0biB > >										20
761 //	        < 21 ; 40M ; MAY 2021 ; opt. ; - ; 0 ; 1,04924082169297 ; -1 ; -0,00025 ; 0,00025 ; 2,4 ; -6,8 ; -2 ; 1,6 ; 3,5 ; 5,1 ; -0,21 ; NABEURMA2171 ; EbDf1604c1A4EaBC9fe6ecAFdCEE4deFBfEEea9BFEf5ec4FeD96Bc70c8dD5a58 ; < 5reS9QDU2Jt1TLzEz25nUf4pS91q5mDJe334VhpwHJ6GMeZ1q2a82nZCX21OZb69 > >										21
762 //	        < 22 ; 42M ; JUL 2021 ; opt. ; - ; 0 ; 1,05396671459775 ; -1 ; -0,00025 ; 0,00025 ; 9,1 ; 4,9 ; -7,3 ; -0,3 ; -2,8 ; 7,9 ; -0,97 ; NABEURJU2115 ; b734B8eDa418DE267bfa010E466dfe3c994BC3b5C890E21dc26b7e1a9cD7B83a ; < 5q1Gf021EhEX5K4P9hXmUOFXRkiDBxeJi2ApCpKoW94u2RJG4BI7Kk0B4r9KUVLQ > >										22
763 //	        < 23 ; 44M ; SEP 2021 ; opt. ; - ; 0 ; 1,05907861835916 ; -1 ; -0,00025 ; 0,00025 ; -2,2 ; -7,6 ; 3,7 ; 0,5 ; -4 ; -1,1 ; 0,62 ; NABEURSE2178 ; 917dAaAb2ABADFCF8fcddeE7AA9Eed37f07f5159adDb093BeFC8e4e8e60BeEaB ; < 1D833wPG6Tp5Ufoj8xfx617969Mx5mmt80YOqi6V7523t8DxvmC920t42e8iqm5v > >										23
764 //	        < 24 ; 47M ; DEC 2021 ; opt. ; - ; 0 ; 1,0643160268966 ; -1 ; -0,00025 ; 0,00025 ; -9,2 ; -2,4 ; -0,2 ; 2 ; 1 ; -4,9 ; -0,07 ; NABEURDE2157 ; e82cf2220271bE9dd5D66fCfd329FFc1B9F0fDEcE3faBE8C9eDCE2BeE2cA2C1a ; < z40RCxvgSGy147H2c8dHcfNLh821rBvn6a8lEReP547loOWX3e15xL5D5R850KvN > >										24
765 											
766 //	  < CALLS ; 24M ; Strike ; Symbol ; Last ; T(-1) ; Change ; Volume ; BAS_1 ; BAS_2 ; o.i. @ eth_hex ; @ btc_882 >										
767 											
768 //	#DIV/0 !										1
769 //	#DIV/0 !										2
770 //	#DIV/0 !										3
771 //	#DIV/0 !										4
772 //	#DIV/0 !										5
773 //	#DIV/0 !										6
774 //	#DIV/0 !										7
775 //	#DIV/0 !										8
776 //	#DIV/0 !										9
777 //	#DIV/0 !										10
778 //	#DIV/0 !										11
779 //	#DIV/0 !										12
780 //	#DIV/0 !										13
781 //	#DIV/0 !										14
782 //	#DIV/0 !										15
783 //	#DIV/0 !										16
784 //	#DIV/0 !										17
785 //	#DIV/0 !										18
786 //	#DIV/0 !										19
787 //	#DIV/0 !										20
788 //	#DIV/0 !										21
789 //											
790 //	  < PUTS ; 24M ; Strike ; Symbol ; Last ; T(-1) ; Change ; Volume ; BAS_1 ; BAS_2 ; o.i. @ eth_hex ; @ btc_882 >										
791 //											
792 //	#DIV/0 !										1
793 //	#DIV/0 !										2
794 //	#DIV/0 !										3
795 //	#DIV/0 !										4
796 //	#DIV/0 !										5
797 //	#DIV/0 !										6
798 //	#DIV/0 !										7
799 //	#DIV/0 !										8
800 //	#DIV/0 !										9
801 //	#DIV/0 !										10
802 //	#DIV/0 !										11
803 //	#DIV/0 !										12
804 //	#DIV/0 !										13
805 //	#DIV/0 !										14
806 //	#DIV/0 !										15
807 //	#DIV/0 !										16
808 //	#DIV/0 !										17
809 //	#DIV/0 !										18
810 //	#DIV/0 !										19
811 //	#DIV/0 !										20
812 //	#DIV/0 !										21
813 											
814 											
815 											
816 											
817 											
818 //	NABEUR										
819 											
820 //	  < # ; REF ; Month ; Optionchain ; Chart ; Last ; T(-1) ; Change ; BAS_1 ; BAS_2 ; Prior. Settle ; Open ; High ; Low ; Volume ; Hi / Lo ; Updated (s) ; Code ; @ eth_hex ; @ btc_882 >										
821 											
822 //	        < 0 ; T0 ; - ; - ; - ; 0 ; 1 ; -1 ; - ; - ; - ; - ; - ; - ; - ; - ; - ; - ; f4AddAd7aaAc515DCFAD905Cc3Efa08cfEae8EF5Ae1F63Dfe7bcDcf23bf77ADA ; < to6Od76JFlu03IYs1nj527h6uJlLLYTm5282x757SG997ww449E1a0tZHpw467da > >										0
823 //	        < 1 ; 0M ; JAN 2019 ; opt. ; - ; 0 ; 1,00026609499864 ; -1 ; -0,00025 ; 0,00025 ; -6 ; -0,2 ; 1,6 ; -5,3 ; -3,6 ; 6,5 ; -0,06 ; NABEUR26JA19 ; f2C9dDE6b26A4bADEe4cc9Ef2FedAbEDabEa2BDBBFB21Fdd3C0f0edBFDca2Bb6 ; < 92J4ya37SZ0k76941BELR494r7qJeZg8C18qkS6mWlQ8bA5JwIH780AjpGZvxEtr > >										1
824 //	        < 2 ; 2M ; MAR 2019 ; opt. ; - ; 0 ; 1,00074045449057 ; -1 ; -0,00025 ; 0,00025 ; 2,5 ; 3,6 ; 6,8 ; -8,6 ; -3,6 ; -7,6 ; 0,53 ; NABEURMA1936 ; 76CADAa0dCAD4f9e28BC74fE36eeFBEfE0c9CACE2b9776e55b0FBF5Ae847c9e6 ; < aDwt79SowQO5Jght4jMa4q9HbJ4Dxg3sCHyK6E5K38KNkMxxUw4RYF1B9J4eQ8LM > >										2
825 //	        < 3 ; 4M ; MAY 2019 ; opt. ; - ; 0 ; 1,00137633990192 ; -1 ; -0,00025 ; 0,00025 ; 9,4 ; 7,9 ; 9,5 ; -8,5 ; -0,4 ; -7,6 ; 0,86 ; NABEURMA1934 ; 7fdCCd9bCcFdFA6cDA36ACD1EBFC173C70Fb9BfE9BBe952efbAADfb890622c2a ; < jO618x9ekJ1Lv1XC0A6q53yEWscZpiC7RB7da97L32bR5r6aIPm75DW7CWFBYA06 > >										3
826 //	        < 4 ; 6M ; JUL 2019 ; opt. ; - ; 0 ; 1,002286230351 ; -1 ; -0,00025 ; 0,00025 ; 7,4 ; 4,8 ; 7,4 ; 5,6 ; 9 ; -8,7 ; 0,63 ; NABEURJU1956 ; adeb1be4CaC7CEC2FF6B8Def4B04EdAebEa0ab08Ee40F632ceEDad3Ae3770C7f ; < h9KiF3XQO1ce6oS1qkKn5dfEBRA2YR35c1P159gH27JPFu8i0HHQP8q3P1ZZ23eq > >										4
827 //	        < 5 ; 8M ; SEP 2019 ; opt. ; - ; 0 ; 1,00336860738833 ; -1 ; -0,00025 ; 0,00025 ; 7 ; -8,3 ; 0,7 ; -1,5 ; 4,5 ; -8,1 ; -0,59 ; NABEURSE1946 ; CaE2261bbaf5cBECBFdCfB4Ad2Ea2473fFd8BC7bD0f8F73dFACccECC1DBDc6af ; < zsRU1zArGtZiy309z3k2C00WdGVErZ7O1t9W7FO7r3BOP9E620ldq9GP588bB5I8 > >										5
828 //	        < 6 ; 11M ; DEC 2019 ; opt. ; - ; 0 ; 1,00464410935353 ; -1 ; -0,00025 ; 0,00025 ; 5,4 ; -8 ; 7,6 ; -1 ; 4,6 ; 1,2 ; -0,37 ; NABEURDE1943 ; 3D9e234BA02FAcb1DaF3CaBCFE91361BD1afdC9eD42abc453C4b2fAACd8409E0 ; < gpAZ47OvET1pRg0pQD87yqF84pUinmn5pVX73kshaPTMK3JqV54qC2Kaz9Q1cWwk > >										6
829 //	        < 7 ; 12M ; JAN 2020 ; opt. ; - ; 0 ; 1,00601301197941 ; -1 ; -0,00025 ; 0,00025 ; -8 ; -9,1 ; -9,1 ; 2,3 ; 7 ; -9,7 ; 0,13 ; NABEURJA2055 ; daacACddFE3abFf12fafdcA7eDbE4aD49fDd4303a6b6bF2fAa8F356EDA38bfA4 ; < OlTW7ZyeVHBImUL1ezKLrK2q52204WYB2JSG010aD0q96AGc71pbJT4LknHOVU3t > >										7
830 //	        < 8 ; 14M ; MAR 2020 ; opt. ; - ; 0 ; 1,00770107464382 ; -1 ; -0,00025 ; 0,00025 ; 7,3 ; -4 ; -5,2 ; 9,8 ; -5 ; -3,8 ; -0,64 ; NABEURMA2056 ; 1AEbCbe8FdB51bFd1fA455eFcBAB42FdFCffEebb0eF2fAC8BC554Ab08d0Eed1A ; < J50jNaOyxAQ1Omzu54ljn1NWB5XwUfw4XRf8MPavU6ux411J3t8o2xTg2dfYe3GP > >										8
831 //	        < 9 ; 16M ; MAY 2020 ; opt. ; - ; 0 ; 1,00951031593822 ; -1 ; -0,00025 ; 0,00025 ; -7,1 ; -6,6 ; 0,3 ; 3,6 ; 6,2 ; 3,2 ; 0,96 ; NABEURMA2075 ; FbdFB31EDa92e4ACfa6BddcFFdAbbDe5AEBAefF333Cb8BaDaebAd1afaCA1Bdef ; < C4T3SI0er22kd1B9Y2xZ278uMS9ODlZ1ZM5219wwxtKO2OfmW013g2ww084GE67H > >										9
832 //	        < 10 ; 18M ; JUL 2020 ; opt. ; - ; 0 ; 1,01152216877121 ; -1 ; -0,00025 ; 0,00025 ; -6,6 ; 9,2 ; -0,7 ; 9,9 ; -9,4 ; -2,6 ; -0,7 ; NABEURJU2059 ; A0fac1445fdb0efdAd67F5Ecb1ddfaCa4a5d8e6feaF607FbAd6DfDdaA8f3ec83 ; < 9t2I3N9CkAxA1waJ8ab1ELsq0mf89UK09bju9P9f6K61644nS7N6N4iwsVmgmD3k > >										10
833 //	        < 11 ; 20M ; SEP 2020 ; opt. ; - ; 0 ; 1,01378335391844 ; -1 ; -0,00025 ; 0,00025 ; -3 ; 5,2 ; 7 ; -4,3 ; 3,6 ; 1,8 ; -0,59 ; NABEURSE2053 ; EaEdBEAe86B8cB9C2a751ffdfFdf3Ce5EAf5D43eFBc41BfB3CFbCc8ecbbfeFbc ; < 6w6EFb938Y06481OxD1H2XU04EW50N34ure7877Jld7KRIo4SeiJLHZMO61fP06B > >										11
834 //	        < 12 ; 23M ; DEC 2020 ; opt. ; - ; 0 ; 1,0162438061184 ; -1 ; -0,00025 ; 0,00025 ; -7,7 ; -5,3 ; -4,3 ; 5,5 ; -5,5 ; -2,8 ; -0,75 ; NABEURDE2057 ; DbEaec74bf0cbB8CF2A6E8b0C1dE278c8B1fE1bf5bFcFeFdB1E2D8a97feDd8ee ; < no7gRb56drzRvI6b0a6Z96j3ztslj3j91kB539IP85Eut44t8ojq3Ybm8p0993FW > >										12
835 //	        < 13 ; 24M ; JAN 2021 ; opt. ; - ; 0 ; 1,01890292514512 ; -1 ; -0,00025 ; 0,00025 ; -2,5 ; -8,7 ; -2,6 ; -8,1 ; 3,3 ; 0 ; -0,2 ; NABEURJA2184 ; e8a1C0Fb1cB82AFecfAeF633ce61C4fF27dd1dbA9a6a7BCCe0EDacb9BBf9fCC9 ; < yrSx9HtjYOKzdDaGEWkgozy66NT58969kek0S4zf2M1107g3QD1cgc7hC6AU6pQY > >										13
836 //	        < 14 ; 26M ; MAR 2021 ; opt. ; - ; 0 ; 1,02188145745659 ; -1 ; -0,00025 ; 0,00025 ; 4,9 ; -1,2 ; 0,8 ; 7,5 ; -9,7 ; -7 ; 0,25 ; NABEURMA2199 ; eed7645f2aEFB2dDA36E6db1bdAcD7e1a3e02F1c9909Ad58f19771d8faBa9bB7 ; < 8p38h80WchAdR6NnkqZ3zt7yzBG154moJMa4X2RA7ST6HE5P2OfNO3gVOX2F7y1a > >										14
837 //	        < 15 ; 28M ; MAY 2021 ; opt. ; - ; 0 ; 1,02507276867486 ; -1 ; -0,00025 ; 0,00025 ; -8,3 ; -2,8 ; -7,8 ; 2,9 ; 0,8 ; -9,8 ; 0,87 ; NABEURMA2196 ; A70eE4aa2c95BDFc8c6a3b2A65c8E0f8AEafaab8aFecdCdE1bFf4Ce3f2e4fDCA ; < 1X5SWJzdl11a96EYU91pO1QrGgGY3kP71T02a13XHhm7t21Y8B86Q5266x4w336K > >										15
838 //	        < 16 ; 30M ; JUL 2021 ; opt. ; - ; 0 ; 1,02853312880934 ; -1 ; -0,00025 ; 0,00025 ; -4,4 ; -9,2 ; -7,9 ; 1,8 ; 9,6 ; -6,9 ; -0,73 ; NABEURJU2190 ; fACf6b8d0efa5B1dcD50e8Fd7EcEf1F7BdBeBcca6cef79DbbD422b83DFBF6698 ; < 6PrBR9h1YW7g9Yqe7O057q7eT0vYzVo60H2GIzTs7gqq82r0JnqP9t6wD2shDNxF > >										16
839 //	        < 17 ; 32M ; SEP 2021 ; opt. ; - ; 0 ; 1,03216540423907 ; -1 ; -0,00025 ; 0,00025 ; 6,1 ; -9 ; -2,8 ; 2,8 ; -9,6 ; -7 ; 0,56 ; NABEURSE2158 ; AdDfB4A3dddce7dBfdE8bA8Ce4E07f9fF63CaAFEcDCE76FbecA7B88eE0a7bFB4 ; < 456vbWlP96q6h6MPmEBLLWUKnb02lVUJVwwZOB8f8z56UTquQ6E1U6pUy41sg2nt > >										17
840 //	        < 18 ; 35M ; DEC 2021 ; opt. ; - ; 0 ; 1,03597754487675 ; -1 ; -0,00025 ; 0,00025 ; 0,7 ; -6 ; -0,2 ; -6,6 ; -6,4 ; 1,1 ; -0,55 ; NABEURDE2189 ; D9e9FD3bA280a8Dd0bB95Fe0f05FaBFdA7abbFFb5ffdAAea8f103ecE2eEE78eC ; < DfeBeS81E21W5yn254eb8gYprE20i4T1MfUqTa057f2NQ675lH7Ljig651a0EM3r > >										18
841 //	        < 19 ; 36M ; JAN 2021 ; opt. ; - ; 0 ; 1,0401651925952 ; -1 ; -0,00025 ; 0,00025 ; -8,9 ; 4,6 ; 6,6 ; 8,4 ; 9,9 ; -2,5 ; -0,67 ; NABEURJA2173 ; b02AFdeefB6f77BfaEfBb71ebFFfffB7bfd0a9f30b6b9Cce78Dd00aAfcEBce79 ; < Q86Hg9XX45JeiVng3NUzjhkpibSMok88Sw6Qk1u03672778af0QLtL34mtXtY69O > >										19
842 //	        < 20 ; 38M ; MAR 2021 ; opt. ; - ; 0 ; 1,04460164060659 ; -1 ; -0,00025 ; 0,00025 ; 9,3 ; 5,9 ; 3,3 ; -5 ; 8,2 ; -5,5 ; -0,25 ; NABEURMA2182 ; dbb48caFae7cD5Fb2b1fEafc19aDdBfaeea9Dc324cea8EFC8d395A824f3DBad6 ; < rcXO3b06fE3bg0cnPWy3EDNYrs418LBSBp2Lf4vpvQ5jIBBc3pKHK1526CrO0biB > >										20
843 //	        < 21 ; 40M ; MAY 2021 ; opt. ; - ; 0 ; 1,04924082169297 ; -1 ; -0,00025 ; 0,00025 ; 2,4 ; -6,8 ; -2 ; 1,6 ; 3,5 ; 5,1 ; -0,21 ; NABEURMA2171 ; EbDf1604c1A4EaBC9fe6ecAFdCEE4deFBfEEea9BFEf5ec4FeD96Bc70c8dD5a58 ; < 5reS9QDU2Jt1TLzEz25nUf4pS91q5mDJe334VhpwHJ6GMeZ1q2a82nZCX21OZb69 > >										21
844 //	        < 22 ; 42M ; JUL 2021 ; opt. ; - ; 0 ; 1,05396671459775 ; -1 ; -0,00025 ; 0,00025 ; 9,1 ; 4,9 ; -7,3 ; -0,3 ; -2,8 ; 7,9 ; -0,97 ; NABEURJU2115 ; b734B8eDa418DE267bfa010E466dfe3c994BC3b5C890E21dc26b7e1a9cD7B83a ; < 5q1Gf021EhEX5K4P9hXmUOFXRkiDBxeJi2ApCpKoW94u2RJG4BI7Kk0B4r9KUVLQ > >										22
845 //	        < 23 ; 44M ; SEP 2021 ; opt. ; - ; 0 ; 1,05907861835916 ; -1 ; -0,00025 ; 0,00025 ; -2,2 ; -7,6 ; 3,7 ; 0,5 ; -4 ; -1,1 ; 0,62 ; NABEURSE2178 ; 917dAaAb2ABADFCF8fcddeE7AA9Eed37f07f5159adDb093BeFC8e4e8e60BeEaB ; < 1D833wPG6Tp5Ufoj8xfx617969Mx5mmt80YOqi6V7523t8DxvmC920t42e8iqm5v > >										23
846 //	        < 24 ; 47M ; DEC 2021 ; opt. ; - ; 0 ; 1,0643160268966 ; -1 ; -0,00025 ; 0,00025 ; -9,2 ; -2,4 ; -0,2 ; 2 ; 1 ; -4,9 ; -0,07 ; NABEURDE2157 ; e82cf2220271bE9dd5D66fCfd329FFc1B9F0fDEcE3faBE8C9eDCE2BeE2cA2C1a ; < z40RCxvgSGy147H2c8dHcfNLh821rBvn6a8lEReP547loOWX3e15xL5D5R850KvN > >										24
847 											
848 //	  < CALLS ; 36M ; Strike ; Symbol ; Last ; T(-1) ; Change ; Volume ; BAS_1 ; BAS_2 ; o.i. @ eth_hex ; @ btc_882 >										
849 											
850 //	#DIV/0 !										1
851 //	#DIV/0 !										2
852 //	#DIV/0 !										3
853 //	#DIV/0 !										4
854 //	#DIV/0 !										5
855 //	#DIV/0 !										6
856 //	#DIV/0 !										7
857 //	#DIV/0 !										8
858 //	#DIV/0 !										9
859 //	#DIV/0 !										10
860 //	#DIV/0 !										11
861 //	#DIV/0 !										12
862 //	#DIV/0 !										13
863 //	#DIV/0 !										14
864 //	#DIV/0 !										15
865 //	#DIV/0 !										16
866 //	#DIV/0 !										17
867 //	#DIV/0 !										18
868 //	#DIV/0 !										19
869 //	#DIV/0 !										20
870 //	#DIV/0 !										21
871 //											
872 //	  < PUTS ; 36M ; Strike ; Symbol ; Last ; T(-1) ; Change ; Volume ; BAS_1 ; BAS_2 ; o.i. @ eth_hex ; @ btc_882 >										
873 //											
874 //	#DIV/0 !										1
875 //	#DIV/0 !										2
876 //	#DIV/0 !										3
877 //	#DIV/0 !										4
878 //	#DIV/0 !										5
879 //	#DIV/0 !										6
880 //	#DIV/0 !										7
881 //	#DIV/0 !										8
882 //	#DIV/0 !										9
883 //	#DIV/0 !										10
884 //	#DIV/0 !										11
885 //	#DIV/0 !										12
886 //	#DIV/0 !										13
887 //	#DIV/0 !										14
888 //	#DIV/0 !										15
889 //	#DIV/0 !										16
890 //	#DIV/0 !										17
891 //	#DIV/0 !										18
892 //	#DIV/0 !										19
893 //	#DIV/0 !										20
894 //	#DIV/0 !										21
895 											
896 											
897 											
898 											
899 											
900 //	NABRUB										
901 											
902 //	  < # ; REF ; Month ; Optionchain ; Chart ; Last ; T(-1) ; Change ; BAS_1 ; BAS_2 ; Prior. Settle ; Open ; High ; Low ; Volume ; Hi / Lo ; Updated (s) ; Code ; @ eth_hex ; @ btc_882 >										
903 											
904 //	        < 0 ; T0 ; - ; - ; - ; 0 ; 1,14 ; -1 ; - ; - ; - ; - ; - ; - ; - ; - ; - ; - ; FacEfABEc15492BA55AcaaAece7CFEE2CC5E36aabdCEDfD809e0FFe7BfDBA9Ad ; < zot500hG0Lxr6CaU30Mrg84xyiCd77v86G15eM2F1hV5cptLQ1Pzs9pcW497982h > >										0
905 //	        < 1 ; 0M ; JAN 2019 ; opt. ; - ; 0 ; 1,14021100829845 ; -1 ; -0,00025 ; 0,00025 ; 8,6 ; 6,1 ; -4 ; -7,1 ; -8,9 ; 3,3 ; -0,11 ; NABRUB16JA19 ; AeC73b4d6aF50E8dDff5FA9C4CF47DFfEA6F4E260ab6B8FeB7Abcb5BEd2ae115 ; < DZT5fnz4H0nbk5Vz6rqL9RqHdxehf75R445fQ86rmCZ2wI64AdkzcO51Ft17tK15 > >										1
906 //	        < 2 ; 2M ; MAR 2019 ; opt. ; - ; 0 ; 1,14072893010838 ; -1 ; -0,00025 ; 0,00025 ; 0,3 ; -8,6 ; 7,9 ; -3,8 ; 0,9 ; 7,1 ; -0,41 ; NABRUBMA1976 ; aE2504D6dEBaA32D1be7DD23ADAC7a2fb9F6ddF7c1EBcc7d8f54fff9dC4DCe2E ; < Rm340ZMA35919KNYf9t3A0WkLX8fi31q94207B14wVLcH49FyGT8MHQ77gH3KzY9 > >										2
907 //	        < 3 ; 4M ; MAY 2019 ; opt. ; - ; 0 ; 1,14151878783416 ; -1 ; -0,00025 ; 0,00025 ; 8,3 ; -7,9 ; 2,2 ; 1,7 ; -8,7 ; 7,3 ; -0,08 ; NABRUBMA1940 ; d65BbBc2a1AD5afD3ceCA65FB4E542fFE47e9C5366EeDb9Adfd9Ed82e47CAc3B ; < 5I13m5QQ8N8cy51KESaR2mDL5I55wo7T8x2tmIHO70Lt4M5cdYci2F3n0D3np6us > >										3
908 //	        < 4 ; 6M ; JUL 2019 ; opt. ; - ; 0 ; 1,14245213908666 ; -1 ; -0,00025 ; 0,00025 ; 4,2 ; -9,6 ; 6,2 ; -7 ; 8,3 ; 5,2 ; 0,61 ; NABRUBJU1923 ; e4BeEeB3Fb0cadf0cA9311E1b1BeACEc4Ff04Ea1FD3c5b92fd5DEfdDec5B7FDE ; < VMWd2947ZETt9W1f31A43IWr0qi36mVZD56K48zeY1hpiP5Dk2mGchzQqhgm2Ajp > >										4
909 //	        < 5 ; 8M ; SEP 2019 ; opt. ; - ; 0 ; 1,14356135514363 ; -1 ; -0,00025 ; 0,00025 ; -9,2 ; 9,7 ; -7,1 ; 4,2 ; 1,5 ; -8,1 ; -0,26 ; NABRUBSE1913 ; CFEC2EEcBbBb1DeeafCCFb15df5DE5F3AaeEfc23EAAc7796AbCafccccfB295Cb ; < k4BQNMe0S3z5vvHgc603VOkVjazfJUb1MHjve82ZCydzJQ9thHcLJH8QrfxXlByE > >										5
910 //	        < 6 ; 11M ; DEC 2019 ; opt. ; - ; 0 ; 1,14493273647751 ; -1 ; -0,00025 ; 0,00025 ; 6 ; 6,6 ; -4,7 ; -9,4 ; -4,2 ; 2,2 ; 0,83 ; NABRUBDE1952 ; eCDF1efbEd9A5dCAe31Dd6caEaC1291afaFBDD5eA47e5f04CC8dd6ffDAcFFfBD ; < igVHHCiciMhdR50Ua5qBQ8P78wR7J7kKSziAQP86MRJN7gaYs71rny9KLmWsq37R > >										6
911 //	        < 7 ; 12M ; JAN 2020 ; opt. ; - ; 0 ; 1,14658324252079 ; -1 ; -0,00025 ; 0,00025 ; 5,7 ; 9,6 ; 3,4 ; -9,9 ; 4,1 ; -2,5 ; -0,1 ; NABRUBJA2012 ; 3Ca0fdDEac1F7F27fD60Fb9bEdbac27Ac5fDAF1fdccAddCEfDbD63eFACd9f2bB ; < 29wt3xp2Fzi16Zl4TCm58t1w9v2C0KSPaC6KviMj0C8qddG8gQs3Rl9823OlDA9G > >										7
912 //	        < 8 ; 14M ; MAR 2020 ; opt. ; - ; 0 ; 1,14843838324108 ; -1 ; -0,00025 ; 0,00025 ; 0,7 ; 2,9 ; -0,6 ; -4,8 ; -8,3 ; 3,9 ; 0,85 ; NABRUBMA2085 ; bC1ACb5893DDdebAcFEB84a5Cfcc413BB5fa0B4FCAC5A1E1fc11a785f5fBB149 ; < SVgPlpQnc3lqwvsP2TdFTFY1f1isAZ3K4DiD65V0q7F71kzttFSqoC8v759lwOTf > >										8
913 //	        < 9 ; 16M ; MAY 2020 ; opt. ; - ; 0 ; 1,15053935326926 ; -1 ; -0,00025 ; 0,00025 ; 9,3 ; -0,2 ; -8,6 ; -5,2 ; 9 ; 4,1 ; -0,27 ; NABRUBMA2035 ; baABbCFB0bb7dbEc031Dd2231dddBAdcA35a7EDe2EeAB6beB6103641742DAded ; < ZEmHKXKs6JkkHxpf32m23aIdB8hhFnB9T9ns2RN2hfhp1F271oGGtWjhD26kE2ZW > >										9
914 //	        < 10 ; 18M ; JUL 2020 ; opt. ; - ; 0 ; 1,15296572539722 ; -1 ; -0,00025 ; 0,00025 ; -1,8 ; -3,8 ; -8,6 ; -1 ; 0,1 ; 8 ; -0,96 ; NABRUBJU2011 ; aAb2e5CBB2EBC4Dc375ed38eAb0ee3afF7eFbecE8B9bBdB53bcdd60fc1Fb999D ; < vO5dKp8162w054gagf5R50YKz1vBf0g1Sd3910qrKJ40W7mLJflcawmoUEAigO4N > >										10
915 //	        < 11 ; 20M ; SEP 2020 ; opt. ; - ; 0 ; 1,15565954699318 ; -1 ; -0,00025 ; 0,00025 ; 1,5 ; -2 ; 0,7 ; -8,2 ; 4,3 ; 5,9 ; -0,84 ; NABRUBSE2069 ; 35204BA3dA8888fB4B8D0Fc4781acBCc6da2EA49a4cb28afaAE870fe5d7C8F29 ; < qbOynA06C6B4qyx39EEA1wIzGL05coHP440B5Q6EI7Z48PT67Fq9a71oZ450YEfD > >										11
916 //	        < 12 ; 23M ; DEC 2020 ; opt. ; - ; 0 ; 1,15855331849885 ; -1 ; -0,00025 ; 0,00025 ; 4,3 ; 8 ; 2,6 ; -7,6 ; -0,9 ; 0,5 ; 0,07 ; NABRUBDE2078 ; CAebaDb4dcdbCFF7FcDA0CeBeBECa9C99ecBff3A32d962AA2ddbed33db3ebBd4 ; < BXbdOqwTNHLyvX62957Wn6W42f6bn8120Q91NP658dzt24K2gmA38CU8jwL3kIJS > >										12
917 //	        < 13 ; 24M ; JAN 2021 ; opt. ; - ; 0 ; 1,16159986795705 ; -1 ; -0,00025 ; 0,00025 ; -3,6 ; -1,4 ; -1 ; 9,4 ; -8,8 ; 3 ; -0,45 ; NABRUBJA2157 ; 680d53DD08F71cCa7cd51BD4D3Ca3dB9ECCDCDeCACE1FC4abDbDDca67ab356D3 ; < HVmd5OQan6tSo3Yb9jL2VmCa6mjqg13cLHD5z4C8mZoBPV4366uEjK5ZgRWq7sU9 > >										13
918 //	        < 14 ; 26M ; MAR 2021 ; opt. ; - ; 0 ; 1,16501064331307 ; -1 ; -0,00025 ; 0,00025 ; 4,5 ; 4,9 ; 1,5 ; -7,9 ; 6,6 ; -7,4 ; 0,63 ; NABRUBMA2166 ; eaecB6cc7bEaDeE0fa3EA59E7d749Febb7fBCc8dc8d35AC36ea9DC21b280Ce9c ; < YcLj0dW1VZ74YLkcgsE3Uy9fxccQ1Izl4dDDUbQ5hz5yXOtCfR60Y8122t3GaynJ > >										14
919 //	        < 15 ; 28M ; MAY 2021 ; opt. ; - ; 0 ; 1,16875029946288 ; -1 ; -0,00025 ; 0,00025 ; -5,4 ; 8,3 ; -9,3 ; -0,9 ; -4,3 ; 6 ; -0,58 ; NABRUBMA2128 ; 15D1Fe7ABa8FC895db3FA2f31b5BAbbcEAE674F27ADBA19Be8D8aEEDFBdFF90b ; < 5aqMyQWVoLv900r5N037trOp17KH50PQiu6W9EC5Hi9OcOn44awxXS5s86CAUg4t > >										15
920 //	        < 16 ; 30M ; JUL 2021 ; opt. ; - ; 0 ; 1,1725413998806 ; -1 ; -0,00025 ; 0,00025 ; -1,9 ; 3,6 ; 8,8 ; -8,4 ; 4,4 ; 6,1 ; -0,87 ; NABRUBJU2148 ; 8Eb2ACdfAeCC073F22abc3B1cCDfBa6308B7b0bF35Bf39CeA0FEA13DfEBeDBE8 ; < d7Vn70PFeob92XFfj4Niv4lk1NslUYvq0BTiZRmIo1qIkz9m45l3287X5svZRrg0 > >										16
921 //	        < 17 ; 32M ; SEP 2021 ; opt. ; - ; 0 ; 1,17673383383731 ; -1 ; -0,00025 ; 0,00025 ; 8,5 ; -3,6 ; -6,9 ; -2,8 ; -8,3 ; 2,1 ; -0,27 ; NABRUBSE2130 ; Dfb4BdbcFdEdBfa64a7a9eAc5CCDaB2Fd81aBdb6eF6a06A036a8C3Cc9deE6fa5 ; < iJz57Xy6tDW9SWtNhfZz25O8m6SeLB7KQkc7g3o1c3Hin3eOR02J22P9w7I514tz > >										17
922 //	        < 18 ; 35M ; DEC 2021 ; opt. ; - ; 0 ; 1,18115875640671 ; -1 ; -0,00025 ; 0,00025 ; 9,2 ; 3,3 ; -9,1 ; -6 ; 9,6 ; -7 ; -0,12 ; NABRUBDE2186 ; bbCe5A14250fDDaEA1F5EbBB2c76fcB3eba2cAf7A6AC2bD4CAFDcDBfeCb7DFb4 ; < FtI34q79Co8NT14DTEt19FmYxfmtff3Yr666YHsqcnMh544Xa54qqBF6Ufj2iNVT > >										18
923 //	        < 19 ; 36M ; JAN 2021 ; opt. ; - ; 0 ; 1,18578561347666 ; -1 ; -0,00025 ; 0,00025 ; 9,6 ; 6,8 ; 2 ; -9,6 ; 5,1 ; -6,2 ; 0,03 ; NABRUBJA2172 ; D4B5FeAbd5Bf6635efc2dfccbD12CEdBEE03Aecb8bAc2ebDaEa92CeB3aDdb67A ; < k38v0At8YIbjAXbO0h8XIsHa2QVT8P41QJVuS074bUll2182SUu6mgg1EzxB8YoF > >										19
924 //	        < 20 ; 38M ; MAR 2021 ; opt. ; - ; 0 ; 1,19083840952538 ; -1 ; -0,00025 ; 0,00025 ; -5,7 ; -5,6 ; 9,8 ; 9,2 ; -1,2 ; 2,9 ; 0,37 ; NABRUBMA2167 ; CA0EdfeFfc9BfF9fcb3fFD5933b96A05B47a39F0e1DC25aECcdAD8CFa3CbD5Ea ; < oPW1dBufssq1LUnK1H84Dv828NhEAL0rAt8v8ts04JW54c3ysoJ8DyeMv1f8Y448 > >										20
925 //	        < 21 ; 40M ; MAY 2021 ; opt. ; - ; 0 ; 1,19602939408026 ; -1 ; -0,00025 ; 0,00025 ; -3,5 ; -1,2 ; 8,6 ; -4 ; -2,8 ; -6,4 ; 0,11 ; NABRUBMA2126 ; fed12aCDf4Eeaae8AEfDBa498BCe5f5baAd3eF44bf33D0Abc8D3BeD967D25deE ; < nk0s72aab4KU8NxP5Di57dVNb9b90y6Iltu7bj0X5SUhH9543w3B6ks4y9xASA1E > >										21
926 //	        < 22 ; 42M ; JUL 2021 ; opt. ; - ; 0 ; 1,20145710341736 ; -1 ; -0,00025 ; 0,00025 ; 0,7 ; -0,8 ; 3,7 ; 8,4 ; -8,9 ; 2,2 ; -0,79 ; NABRUBJU2125 ; 77F7eFDBcabDaaD4d47Ca1d5da3dfAdD26B9C6bbebB7cEEcfaE917b3a5eaFBa1 ; < LtH7xCdIyURViVW1QB5c0jM67xJ9GmU7RdL2kSeN9I3059M2g999uz4Q0mUK52ru > >										22
927 //	        < 23 ; 44M ; SEP 2021 ; opt. ; - ; 0 ; 1,20718583919927 ; -1 ; -0,00025 ; 0,00025 ; 5,1 ; 8,3 ; -6,2 ; -5,9 ; -6,2 ; -2 ; 0,29 ; NABRUBSE2153 ; 56Caec1C2AFb5EeAe0bc1dcCb29DeFaDbdca32e78CCDACFDc67Bb85FAB4CBd3c ; < bcwt1s84AvUCro481ue580G4BRA7eDjzCQ4vl4F9B12o0C3cNuKybCTJ5FN4sBv6 > >										23
928 //	        < 24 ; 47M ; DEC 2021 ; opt. ; - ; 0 ; 1,2131689540148 ; -1 ; -0,00025 ; 0,00025 ; 3,4 ; 1,7 ; 1,2 ; 6,9 ; 0,8 ; 7,7 ; 0,13 ; NABRUBDE2192 ; 2dCd740eDfCbDDCebc3CAdcc1dC59d7CE9dDF1A0CDbDcfc6Ab0BCd0DeC8a66EB ; < 4163pB13V4HV45KXfbli104pe8wp038Ug7CC8Lrz8R7GxuQPyDR16Cm1p9Td6nge > >										24
929 											
930 //	  < CALLS ; 3M ; Strike ; Symbol ; Last ; T(-1) ; Change ; Volume ; BAS_1 ; BAS_2 ; o.i. @ eth_hex ; @ btc_882 >										
931 											
932 //	#DIV/0 !										1
933 //	#DIV/0 !										2
934 //	#DIV/0 !										3
935 //	#DIV/0 !										4
936 //	#DIV/0 !										5
937 //	#DIV/0 !										6
938 //	#DIV/0 !										7
939 //	#DIV/0 !										8
940 //	#DIV/0 !										9
941 //	#DIV/0 !										10
942 //	#DIV/0 !										11
943 //	#DIV/0 !										12
944 //	#DIV/0 !										13
945 //	#DIV/0 !										14
946 //	#DIV/0 !										15
947 //	#DIV/0 !										16
948 //	#DIV/0 !										17
949 //	#DIV/0 !										18
950 //	#DIV/0 !										19
951 //	#DIV/0 !										20
952 //	#DIV/0 !										21
953 //											
954 //	  < PUTS ; 3M ; Strike ; Symbol ; Last ; T(-1) ; Change ; Volume ; BAS_1 ; BAS_2 ; o.i. @ eth_hex ; @ btc_882 >										
955 //											
956 //	#DIV/0 !										1
957 //	#DIV/0 !										2
958 //	#DIV/0 !										3
959 //	#DIV/0 !										4
960 //	#DIV/0 !										5
961 //	#DIV/0 !										6
962 //	#DIV/0 !										7
963 //	#DIV/0 !										8
964 //	#DIV/0 !										9
965 //	#DIV/0 !										10
966 //	#DIV/0 !										11
967 //	#DIV/0 !										12
968 //	#DIV/0 !										13
969 //	#DIV/0 !										14
970 //	#DIV/0 !										15
971 //	#DIV/0 !										16
972 //	#DIV/0 !										17
973 //	#DIV/0 !										18
974 //	#DIV/0 !										19
975 //	#DIV/0 !										20
976 //	#DIV/0 !										21
977 											
978 											
979 											
980 											
981 											
982 //	NABRUB										
983 											
984 //	  < # ; REF ; Month ; Optionchain ; Chart ; Last ; T(-1) ; Change ; BAS_1 ; BAS_2 ; Prior. Settle ; Open ; High ; Low ; Volume ; Hi / Lo ; Updated (s) ; Code ; @ eth_hex ; @ btc_882 >										
985 											
986 //	        < 0 ; T0 ; - ; - ; - ; 0 ; 1,14 ; -1 ; - ; - ; - ; - ; - ; - ; - ; - ; - ; - ; FacEfABEc15492BA55AcaaAece7CFEE2CC5E36aabdCEDfD809e0FFe7BfDBA9Ad ; < zot500hG0Lxr6CaU30Mrg84xyiCd77v86G15eM2F1hV5cptLQ1Pzs9pcW497982h > >										0
987 //	        < 1 ; 0M ; JAN 2019 ; opt. ; - ; 0 ; 1,14021100829845 ; -1 ; -0,00025 ; 0,00025 ; 8,6 ; 6,1 ; -4 ; -7,1 ; -8,9 ; 3,3 ; -0,11 ; NABRUB16JA19 ; AeC73b4d6aF50E8dDff5FA9C4CF47DFfEA6F4E260ab6B8FeB7Abcb5BEd2ae115 ; < DZT5fnz4H0nbk5Vz6rqL9RqHdxehf75R445fQ86rmCZ2wI64AdkzcO51Ft17tK15 > >										1
988 //	        < 2 ; 2M ; MAR 2019 ; opt. ; - ; 0 ; 1,14072893010838 ; -1 ; -0,00025 ; 0,00025 ; 0,3 ; -8,6 ; 7,9 ; -3,8 ; 0,9 ; 7,1 ; -0,41 ; NABRUBMA1976 ; aE2504D6dEBaA32D1be7DD23ADAC7a2fb9F6ddF7c1EBcc7d8f54fff9dC4DCe2E ; < Rm340ZMA35919KNYf9t3A0WkLX8fi31q94207B14wVLcH49FyGT8MHQ77gH3KzY9 > >										2
989 //	        < 3 ; 4M ; MAY 2019 ; opt. ; - ; 0 ; 1,14151878783416 ; -1 ; -0,00025 ; 0,00025 ; 8,3 ; -7,9 ; 2,2 ; 1,7 ; -8,7 ; 7,3 ; -0,08 ; NABRUBMA1940 ; d65BbBc2a1AD5afD3ceCA65FB4E542fFE47e9C5366EeDb9Adfd9Ed82e47CAc3B ; < 5I13m5QQ8N8cy51KESaR2mDL5I55wo7T8x2tmIHO70Lt4M5cdYci2F3n0D3np6us > >										3
990 //	        < 4 ; 6M ; JUL 2019 ; opt. ; - ; 0 ; 1,14245213908666 ; -1 ; -0,00025 ; 0,00025 ; 4,2 ; -9,6 ; 6,2 ; -7 ; 8,3 ; 5,2 ; 0,61 ; NABRUBJU1923 ; e4BeEeB3Fb0cadf0cA9311E1b1BeACEc4Ff04Ea1FD3c5b92fd5DEfdDec5B7FDE ; < VMWd2947ZETt9W1f31A43IWr0qi36mVZD56K48zeY1hpiP5Dk2mGchzQqhgm2Ajp > >										4
991 //	        < 5 ; 8M ; SEP 2019 ; opt. ; - ; 0 ; 1,14356135514363 ; -1 ; -0,00025 ; 0,00025 ; -9,2 ; 9,7 ; -7,1 ; 4,2 ; 1,5 ; -8,1 ; -0,26 ; NABRUBSE1913 ; CFEC2EEcBbBb1DeeafCCFb15df5DE5F3AaeEfc23EAAc7796AbCafccccfB295Cb ; < k4BQNMe0S3z5vvHgc603VOkVjazfJUb1MHjve82ZCydzJQ9thHcLJH8QrfxXlByE > >										5
992 //	        < 6 ; 11M ; DEC 2019 ; opt. ; - ; 0 ; 1,14493273647751 ; -1 ; -0,00025 ; 0,00025 ; 6 ; 6,6 ; -4,7 ; -9,4 ; -4,2 ; 2,2 ; 0,83 ; NABRUBDE1952 ; eCDF1efbEd9A5dCAe31Dd6caEaC1291afaFBDD5eA47e5f04CC8dd6ffDAcFFfBD ; < igVHHCiciMhdR50Ua5qBQ8P78wR7J7kKSziAQP86MRJN7gaYs71rny9KLmWsq37R > >										6
993 //	        < 7 ; 12M ; JAN 2020 ; opt. ; - ; 0 ; 1,14658324252079 ; -1 ; -0,00025 ; 0,00025 ; 5,7 ; 9,6 ; 3,4 ; -9,9 ; 4,1 ; -2,5 ; -0,1 ; NABRUBJA2012 ; 3Ca0fdDEac1F7F27fD60Fb9bEdbac27Ac5fDAF1fdccAddCEfDbD63eFACd9f2bB ; < 29wt3xp2Fzi16Zl4TCm58t1w9v2C0KSPaC6KviMj0C8qddG8gQs3Rl9823OlDA9G > >										7
994 //	        < 8 ; 14M ; MAR 2020 ; opt. ; - ; 0 ; 1,14843838324108 ; -1 ; -0,00025 ; 0,00025 ; 0,7 ; 2,9 ; -0,6 ; -4,8 ; -8,3 ; 3,9 ; 0,85 ; NABRUBMA2085 ; bC1ACb5893DDdebAcFEB84a5Cfcc413BB5fa0B4FCAC5A1E1fc11a785f5fBB149 ; < SVgPlpQnc3lqwvsP2TdFTFY1f1isAZ3K4DiD65V0q7F71kzttFSqoC8v759lwOTf > >										8
995 //	        < 9 ; 16M ; MAY 2020 ; opt. ; - ; 0 ; 1,15053935326926 ; -1 ; -0,00025 ; 0,00025 ; 9,3 ; -0,2 ; -8,6 ; -5,2 ; 9 ; 4,1 ; -0,27 ; NABRUBMA2035 ; baABbCFB0bb7dbEc031Dd2231dddBAdcA35a7EDe2EeAB6beB6103641742DAded ; < ZEmHKXKs6JkkHxpf32m23aIdB8hhFnB9T9ns2RN2hfhp1F271oGGtWjhD26kE2ZW > >										9
996 //	        < 10 ; 18M ; JUL 2020 ; opt. ; - ; 0 ; 1,15296572539722 ; -1 ; -0,00025 ; 0,00025 ; -1,8 ; -3,8 ; -8,6 ; -1 ; 0,1 ; 8 ; -0,96 ; NABRUBJU2011 ; aAb2e5CBB2EBC4Dc375ed38eAb0ee3afF7eFbecE8B9bBdB53bcdd60fc1Fb999D ; < vO5dKp8162w054gagf5R50YKz1vBf0g1Sd3910qrKJ40W7mLJflcawmoUEAigO4N > >										10
997 //	        < 11 ; 20M ; SEP 2020 ; opt. ; - ; 0 ; 1,15565954699318 ; -1 ; -0,00025 ; 0,00025 ; 1,5 ; -2 ; 0,7 ; -8,2 ; 4,3 ; 5,9 ; -0,84 ; NABRUBSE2069 ; 35204BA3dA8888fB4B8D0Fc4781acBCc6da2EA49a4cb28afaAE870fe5d7C8F29 ; < qbOynA06C6B4qyx39EEA1wIzGL05coHP440B5Q6EI7Z48PT67Fq9a71oZ450YEfD > >										11
998 //	        < 12 ; 23M ; DEC 2020 ; opt. ; - ; 0 ; 1,15855331849885 ; -1 ; -0,00025 ; 0,00025 ; 4,3 ; 8 ; 2,6 ; -7,6 ; -0,9 ; 0,5 ; 0,07 ; NABRUBDE2078 ; CAebaDb4dcdbCFF7FcDA0CeBeBECa9C99ecBff3A32d962AA2ddbed33db3ebBd4 ; < BXbdOqwTNHLyvX62957Wn6W42f6bn8120Q91NP658dzt24K2gmA38CU8jwL3kIJS > >										12
999 //	        < 13 ; 24M ; JAN 2021 ; opt. ; - ; 0 ; 1,16159986795705 ; -1 ; -0,00025 ; 0,00025 ; -3,6 ; -1,4 ; -1 ; 9,4 ; -8,8 ; 3 ; -0,45 ; NABRUBJA2157 ; 680d53DD08F71cCa7cd51BD4D3Ca3dB9ECCDCDeCACE1FC4abDbDDca67ab356D3 ; < HVmd5OQan6tSo3Yb9jL2VmCa6mjqg13cLHD5z4C8mZoBPV4366uEjK5ZgRWq7sU9 > >										13
1000 //	        < 14 ; 26M ; MAR 2021 ; opt. ; - ; 0 ; 1,16501064331307 ; -1 ; -0,00025 ; 0,00025 ; 4,5 ; 4,9 ; 1,5 ; -7,9 ; 6,6 ; -7,4 ; 0,63 ; NABRUBMA2166 ; eaecB6cc7bEaDeE0fa3EA59E7d749Febb7fBCc8dc8d35AC36ea9DC21b280Ce9c ; < YcLj0dW1VZ74YLkcgsE3Uy9fxccQ1Izl4dDDUbQ5hz5yXOtCfR60Y8122t3GaynJ > >										14
1001 //	        < 15 ; 28M ; MAY 2021 ; opt. ; - ; 0 ; 1,16875029946288 ; -1 ; -0,00025 ; 0,00025 ; -5,4 ; 8,3 ; -9,3 ; -0,9 ; -4,3 ; 6 ; -0,58 ; NABRUBMA2128 ; 15D1Fe7ABa8FC895db3FA2f31b5BAbbcEAE674F27ADBA19Be8D8aEEDFBdFF90b ; < 5aqMyQWVoLv900r5N037trOp17KH50PQiu6W9EC5Hi9OcOn44awxXS5s86CAUg4t > >										15
1002 //	        < 16 ; 30M ; JUL 2021 ; opt. ; - ; 0 ; 1,1725413998806 ; -1 ; -0,00025 ; 0,00025 ; -1,9 ; 3,6 ; 8,8 ; -8,4 ; 4,4 ; 6,1 ; -0,87 ; NABRUBJU2148 ; 8Eb2ACdfAeCC073F22abc3B1cCDfBa6308B7b0bF35Bf39CeA0FEA13DfEBeDBE8 ; < d7Vn70PFeob92XFfj4Niv4lk1NslUYvq0BTiZRmIo1qIkz9m45l3287X5svZRrg0 > >										16
1003 //	        < 17 ; 32M ; SEP 2021 ; opt. ; - ; 0 ; 1,17673383383731 ; -1 ; -0,00025 ; 0,00025 ; 8,5 ; -3,6 ; -6,9 ; -2,8 ; -8,3 ; 2,1 ; -0,27 ; NABRUBSE2130 ; Dfb4BdbcFdEdBfa64a7a9eAc5CCDaB2Fd81aBdb6eF6a06A036a8C3Cc9deE6fa5 ; < iJz57Xy6tDW9SWtNhfZz25O8m6SeLB7KQkc7g3o1c3Hin3eOR02J22P9w7I514tz > >										17
1004 //	        < 18 ; 35M ; DEC 2021 ; opt. ; - ; 0 ; 1,18115875640671 ; -1 ; -0,00025 ; 0,00025 ; 9,2 ; 3,3 ; -9,1 ; -6 ; 9,6 ; -7 ; -0,12 ; NABRUBDE2186 ; bbCe5A14250fDDaEA1F5EbBB2c76fcB3eba2cAf7A6AC2bD4CAFDcDBfeCb7DFb4 ; < FtI34q79Co8NT14DTEt19FmYxfmtff3Yr666YHsqcnMh544Xa54qqBF6Ufj2iNVT > >										18
1005 //	        < 19 ; 36M ; JAN 2021 ; opt. ; - ; 0 ; 1,18578561347666 ; -1 ; -0,00025 ; 0,00025 ; 9,6 ; 6,8 ; 2 ; -9,6 ; 5,1 ; -6,2 ; 0,03 ; NABRUBJA2172 ; D4B5FeAbd5Bf6635efc2dfccbD12CEdBEE03Aecb8bAc2ebDaEa92CeB3aDdb67A ; < k38v0At8YIbjAXbO0h8XIsHa2QVT8P41QJVuS074bUll2182SUu6mgg1EzxB8YoF > >										19
1006 //	        < 20 ; 38M ; MAR 2021 ; opt. ; - ; 0 ; 1,19083840952538 ; -1 ; -0,00025 ; 0,00025 ; -5,7 ; -5,6 ; 9,8 ; 9,2 ; -1,2 ; 2,9 ; 0,37 ; NABRUBMA2167 ; CA0EdfeFfc9BfF9fcb3fFD5933b96A05B47a39F0e1DC25aECcdAD8CFa3CbD5Ea ; < oPW1dBufssq1LUnK1H84Dv828NhEAL0rAt8v8ts04JW54c3ysoJ8DyeMv1f8Y448 > >										20
1007 //	        < 21 ; 40M ; MAY 2021 ; opt. ; - ; 0 ; 1,19602939408026 ; -1 ; -0,00025 ; 0,00025 ; -3,5 ; -1,2 ; 8,6 ; -4 ; -2,8 ; -6,4 ; 0,11 ; NABRUBMA2126 ; fed12aCDf4Eeaae8AEfDBa498BCe5f5baAd3eF44bf33D0Abc8D3BeD967D25deE ; < nk0s72aab4KU8NxP5Di57dVNb9b90y6Iltu7bj0X5SUhH9543w3B6ks4y9xASA1E > >										21
1008 //	        < 22 ; 42M ; JUL 2021 ; opt. ; - ; 0 ; 1,20145710341736 ; -1 ; -0,00025 ; 0,00025 ; 0,7 ; -0,8 ; 3,7 ; 8,4 ; -8,9 ; 2,2 ; -0,79 ; NABRUBJU2125 ; 77F7eFDBcabDaaD4d47Ca1d5da3dfAdD26B9C6bbebB7cEEcfaE917b3a5eaFBa1 ; < LtH7xCdIyURViVW1QB5c0jM67xJ9GmU7RdL2kSeN9I3059M2g999uz4Q0mUK52ru > >										22
1009 //	        < 23 ; 44M ; SEP 2021 ; opt. ; - ; 0 ; 1,20718583919927 ; -1 ; -0,00025 ; 0,00025 ; 5,1 ; 8,3 ; -6,2 ; -5,9 ; -6,2 ; -2 ; 0,29 ; NABRUBSE2153 ; 56Caec1C2AFb5EeAe0bc1dcCb29DeFaDbdca32e78CCDACFDc67Bb85FAB4CBd3c ; < bcwt1s84AvUCro481ue580G4BRA7eDjzCQ4vl4F9B12o0C3cNuKybCTJ5FN4sBv6 > >										23
1010 //	        < 24 ; 47M ; DEC 2021 ; opt. ; - ; 0 ; 1,2131689540148 ; -1 ; -0,00025 ; 0,00025 ; 3,4 ; 1,7 ; 1,2 ; 6,9 ; 0,8 ; 7,7 ; 0,13 ; NABRUBDE2192 ; 2dCd740eDfCbDDCebc3CAdcc1dC59d7CE9dDF1A0CDbDcfc6Ab0BCd0DeC8a66EB ; < 4163pB13V4HV45KXfbli104pe8wp038Ug7CC8Lrz8R7GxuQPyDR16Cm1p9Td6nge > >										24
1011 											
1012 //	  < CALLS ; 6M ; Strike ; Symbol ; Last ; T(-1) ; Change ; Volume ; BAS_1 ; BAS_2 ; o.i. @ eth_hex ; @ btc_882 >										
1013 											
1014 //	#DIV/0 !										1
1015 //	#DIV/0 !										2
1016 //	#DIV/0 !										3
1017 //	#DIV/0 !										4
1018 //	#DIV/0 !										5
1019 //	#DIV/0 !										6
1020 //	#DIV/0 !										7
1021 //	#DIV/0 !										8
1022 //	#DIV/0 !										9
1023 //	#DIV/0 !										10
1024 //	#DIV/0 !										11
1025 //	#DIV/0 !										12
1026 //	#DIV/0 !										13
1027 //	#DIV/0 !										14
1028 //	#DIV/0 !										15
1029 //	#DIV/0 !										16
1030 //	#DIV/0 !										17
1031 //	#DIV/0 !										18
1032 //	#DIV/0 !										19
1033 //	#DIV/0 !										20
1034 //	#DIV/0 !										21
1035 //											
1036 //	  < PUTS ; 6M ; Strike ; Symbol ; Last ; T(-1) ; Change ; Volume ; BAS_1 ; BAS_2 ; o.i. @ eth_hex ; @ btc_882 >										
1037 //											
1038 //	#DIV/0 !										1
1039 //	#DIV/0 !										2
1040 //	#DIV/0 !										3
1041 //	#DIV/0 !										4
1042 //	#DIV/0 !										5
1043 //	#DIV/0 !										6
1044 //	#DIV/0 !										7
1045 //	#DIV/0 !										8
1046 //	#DIV/0 !										9
1047 //	#DIV/0 !										10
1048 //	#DIV/0 !										11
1049 //	#DIV/0 !										12
1050 //	#DIV/0 !										13
1051 //	#DIV/0 !										14
1052 //	#DIV/0 !										15
1053 //	#DIV/0 !										16
1054 //	#DIV/0 !										17
1055 //	#DIV/0 !										18
1056 //	#DIV/0 !										19
1057 //	#DIV/0 !										20
1058 //	#DIV/0 !										21
1059 											
1060 											
1061 											
1062 											
1063 											
1064 //	NABRUB										
1065 											
1066 //	  < # ; REF ; Month ; Optionchain ; Chart ; Last ; T(-1) ; Change ; BAS_1 ; BAS_2 ; Prior. Settle ; Open ; High ; Low ; Volume ; Hi / Lo ; Updated (s) ; Code ; @ eth_hex ; @ btc_882 >										
1067 											
1068 //	        < 0 ; T0 ; - ; - ; - ; 0 ; 1,14 ; -1 ; - ; - ; - ; - ; - ; - ; - ; - ; - ; - ; FacEfABEc15492BA55AcaaAece7CFEE2CC5E36aabdCEDfD809e0FFe7BfDBA9Ad ; < zot500hG0Lxr6CaU30Mrg84xyiCd77v86G15eM2F1hV5cptLQ1Pzs9pcW497982h > >										0
1069 //	        < 1 ; 0M ; JAN 2019 ; opt. ; - ; 0 ; 1,14021100829845 ; -1 ; -0,00025 ; 0,00025 ; 8,6 ; 6,1 ; -4 ; -7,1 ; -8,9 ; 3,3 ; -0,11 ; NABRUB16JA19 ; AeC73b4d6aF50E8dDff5FA9C4CF47DFfEA6F4E260ab6B8FeB7Abcb5BEd2ae115 ; < DZT5fnz4H0nbk5Vz6rqL9RqHdxehf75R445fQ86rmCZ2wI64AdkzcO51Ft17tK15 > >										1
1070 //	        < 2 ; 2M ; MAR 2019 ; opt. ; - ; 0 ; 1,14072893010838 ; -1 ; -0,00025 ; 0,00025 ; 0,3 ; -8,6 ; 7,9 ; -3,8 ; 0,9 ; 7,1 ; -0,41 ; NABRUBMA1976 ; aE2504D6dEBaA32D1be7DD23ADAC7a2fb9F6ddF7c1EBcc7d8f54fff9dC4DCe2E ; < Rm340ZMA35919KNYf9t3A0WkLX8fi31q94207B14wVLcH49FyGT8MHQ77gH3KzY9 > >										2
1071 //	        < 3 ; 4M ; MAY 2019 ; opt. ; - ; 0 ; 1,14151878783416 ; -1 ; -0,00025 ; 0,00025 ; 8,3 ; -7,9 ; 2,2 ; 1,7 ; -8,7 ; 7,3 ; -0,08 ; NABRUBMA1940 ; d65BbBc2a1AD5afD3ceCA65FB4E542fFE47e9C5366EeDb9Adfd9Ed82e47CAc3B ; < 5I13m5QQ8N8cy51KESaR2mDL5I55wo7T8x2tmIHO70Lt4M5cdYci2F3n0D3np6us > >										3
1072 //	        < 4 ; 6M ; JUL 2019 ; opt. ; - ; 0 ; 1,14245213908666 ; -1 ; -0,00025 ; 0,00025 ; 4,2 ; -9,6 ; 6,2 ; -7 ; 8,3 ; 5,2 ; 0,61 ; NABRUBJU1923 ; e4BeEeB3Fb0cadf0cA9311E1b1BeACEc4Ff04Ea1FD3c5b92fd5DEfdDec5B7FDE ; < VMWd2947ZETt9W1f31A43IWr0qi36mVZD56K48zeY1hpiP5Dk2mGchzQqhgm2Ajp > >										4
1073 //	        < 5 ; 8M ; SEP 2019 ; opt. ; - ; 0 ; 1,14356135514363 ; -1 ; -0,00025 ; 0,00025 ; -9,2 ; 9,7 ; -7,1 ; 4,2 ; 1,5 ; -8,1 ; -0,26 ; NABRUBSE1913 ; CFEC2EEcBbBb1DeeafCCFb15df5DE5F3AaeEfc23EAAc7796AbCafccccfB295Cb ; < k4BQNMe0S3z5vvHgc603VOkVjazfJUb1MHjve82ZCydzJQ9thHcLJH8QrfxXlByE > >										5
1074 //	        < 6 ; 11M ; DEC 2019 ; opt. ; - ; 0 ; 1,14493273647751 ; -1 ; -0,00025 ; 0,00025 ; 6 ; 6,6 ; -4,7 ; -9,4 ; -4,2 ; 2,2 ; 0,83 ; NABRUBDE1952 ; eCDF1efbEd9A5dCAe31Dd6caEaC1291afaFBDD5eA47e5f04CC8dd6ffDAcFFfBD ; < igVHHCiciMhdR50Ua5qBQ8P78wR7J7kKSziAQP86MRJN7gaYs71rny9KLmWsq37R > >										6
1075 //	        < 7 ; 12M ; JAN 2020 ; opt. ; - ; 0 ; 1,14658324252079 ; -1 ; -0,00025 ; 0,00025 ; 5,7 ; 9,6 ; 3,4 ; -9,9 ; 4,1 ; -2,5 ; -0,1 ; NABRUBJA2012 ; 3Ca0fdDEac1F7F27fD60Fb9bEdbac27Ac5fDAF1fdccAddCEfDbD63eFACd9f2bB ; < 29wt3xp2Fzi16Zl4TCm58t1w9v2C0KSPaC6KviMj0C8qddG8gQs3Rl9823OlDA9G > >										7
1076 //	        < 8 ; 14M ; MAR 2020 ; opt. ; - ; 0 ; 1,14843838324108 ; -1 ; -0,00025 ; 0,00025 ; 0,7 ; 2,9 ; -0,6 ; -4,8 ; -8,3 ; 3,9 ; 0,85 ; NABRUBMA2085 ; bC1ACb5893DDdebAcFEB84a5Cfcc413BB5fa0B4FCAC5A1E1fc11a785f5fBB149 ; < SVgPlpQnc3lqwvsP2TdFTFY1f1isAZ3K4DiD65V0q7F71kzttFSqoC8v759lwOTf > >										8
1077 //	        < 9 ; 16M ; MAY 2020 ; opt. ; - ; 0 ; 1,15053935326926 ; -1 ; -0,00025 ; 0,00025 ; 9,3 ; -0,2 ; -8,6 ; -5,2 ; 9 ; 4,1 ; -0,27 ; NABRUBMA2035 ; baABbCFB0bb7dbEc031Dd2231dddBAdcA35a7EDe2EeAB6beB6103641742DAded ; < ZEmHKXKs6JkkHxpf32m23aIdB8hhFnB9T9ns2RN2hfhp1F271oGGtWjhD26kE2ZW > >										9
1078 //	        < 10 ; 18M ; JUL 2020 ; opt. ; - ; 0 ; 1,15296572539722 ; -1 ; -0,00025 ; 0,00025 ; -1,8 ; -3,8 ; -8,6 ; -1 ; 0,1 ; 8 ; -0,96 ; NABRUBJU2011 ; aAb2e5CBB2EBC4Dc375ed38eAb0ee3afF7eFbecE8B9bBdB53bcdd60fc1Fb999D ; < vO5dKp8162w054gagf5R50YKz1vBf0g1Sd3910qrKJ40W7mLJflcawmoUEAigO4N > >										10
1079 //	        < 11 ; 20M ; SEP 2020 ; opt. ; - ; 0 ; 1,15565954699318 ; -1 ; -0,00025 ; 0,00025 ; 1,5 ; -2 ; 0,7 ; -8,2 ; 4,3 ; 5,9 ; -0,84 ; NABRUBSE2069 ; 35204BA3dA8888fB4B8D0Fc4781acBCc6da2EA49a4cb28afaAE870fe5d7C8F29 ; < qbOynA06C6B4qyx39EEA1wIzGL05coHP440B5Q6EI7Z48PT67Fq9a71oZ450YEfD > >										11
1080 //	        < 12 ; 23M ; DEC 2020 ; opt. ; - ; 0 ; 1,15855331849885 ; -1 ; -0,00025 ; 0,00025 ; 4,3 ; 8 ; 2,6 ; -7,6 ; -0,9 ; 0,5 ; 0,07 ; NABRUBDE2078 ; CAebaDb4dcdbCFF7FcDA0CeBeBECa9C99ecBff3A32d962AA2ddbed33db3ebBd4 ; < BXbdOqwTNHLyvX62957Wn6W42f6bn8120Q91NP658dzt24K2gmA38CU8jwL3kIJS > >										12
1081 //	        < 13 ; 24M ; JAN 2021 ; opt. ; - ; 0 ; 1,16159986795705 ; -1 ; -0,00025 ; 0,00025 ; -3,6 ; -1,4 ; -1 ; 9,4 ; -8,8 ; 3 ; -0,45 ; NABRUBJA2157 ; 680d53DD08F71cCa7cd51BD4D3Ca3dB9ECCDCDeCACE1FC4abDbDDca67ab356D3 ; < HVmd5OQan6tSo3Yb9jL2VmCa6mjqg13cLHD5z4C8mZoBPV4366uEjK5ZgRWq7sU9 > >										13
1082 //	        < 14 ; 26M ; MAR 2021 ; opt. ; - ; 0 ; 1,16501064331307 ; -1 ; -0,00025 ; 0,00025 ; 4,5 ; 4,9 ; 1,5 ; -7,9 ; 6,6 ; -7,4 ; 0,63 ; NABRUBMA2166 ; eaecB6cc7bEaDeE0fa3EA59E7d749Febb7fBCc8dc8d35AC36ea9DC21b280Ce9c ; < YcLj0dW1VZ74YLkcgsE3Uy9fxccQ1Izl4dDDUbQ5hz5yXOtCfR60Y8122t3GaynJ > >										14
1083 //	        < 15 ; 28M ; MAY 2021 ; opt. ; - ; 0 ; 1,16875029946288 ; -1 ; -0,00025 ; 0,00025 ; -5,4 ; 8,3 ; -9,3 ; -0,9 ; -4,3 ; 6 ; -0,58 ; NABRUBMA2128 ; 15D1Fe7ABa8FC895db3FA2f31b5BAbbcEAE674F27ADBA19Be8D8aEEDFBdFF90b ; < 5aqMyQWVoLv900r5N037trOp17KH50PQiu6W9EC5Hi9OcOn44awxXS5s86CAUg4t > >										15
1084 //	        < 16 ; 30M ; JUL 2021 ; opt. ; - ; 0 ; 1,1725413998806 ; -1 ; -0,00025 ; 0,00025 ; -1,9 ; 3,6 ; 8,8 ; -8,4 ; 4,4 ; 6,1 ; -0,87 ; NABRUBJU2148 ; 8Eb2ACdfAeCC073F22abc3B1cCDfBa6308B7b0bF35Bf39CeA0FEA13DfEBeDBE8 ; < d7Vn70PFeob92XFfj4Niv4lk1NslUYvq0BTiZRmIo1qIkz9m45l3287X5svZRrg0 > >										16
1085 //	        < 17 ; 32M ; SEP 2021 ; opt. ; - ; 0 ; 1,17673383383731 ; -1 ; -0,00025 ; 0,00025 ; 8,5 ; -3,6 ; -6,9 ; -2,8 ; -8,3 ; 2,1 ; -0,27 ; NABRUBSE2130 ; Dfb4BdbcFdEdBfa64a7a9eAc5CCDaB2Fd81aBdb6eF6a06A036a8C3Cc9deE6fa5 ; < iJz57Xy6tDW9SWtNhfZz25O8m6SeLB7KQkc7g3o1c3Hin3eOR02J22P9w7I514tz > >										17
1086 //	        < 18 ; 35M ; DEC 2021 ; opt. ; - ; 0 ; 1,18115875640671 ; -1 ; -0,00025 ; 0,00025 ; 9,2 ; 3,3 ; -9,1 ; -6 ; 9,6 ; -7 ; -0,12 ; NABRUBDE2186 ; bbCe5A14250fDDaEA1F5EbBB2c76fcB3eba2cAf7A6AC2bD4CAFDcDBfeCb7DFb4 ; < FtI34q79Co8NT14DTEt19FmYxfmtff3Yr666YHsqcnMh544Xa54qqBF6Ufj2iNVT > >										18
1087 //	        < 19 ; 36M ; JAN 2021 ; opt. ; - ; 0 ; 1,18578561347666 ; -1 ; -0,00025 ; 0,00025 ; 9,6 ; 6,8 ; 2 ; -9,6 ; 5,1 ; -6,2 ; 0,03 ; NABRUBJA2172 ; D4B5FeAbd5Bf6635efc2dfccbD12CEdBEE03Aecb8bAc2ebDaEa92CeB3aDdb67A ; < k38v0At8YIbjAXbO0h8XIsHa2QVT8P41QJVuS074bUll2182SUu6mgg1EzxB8YoF > >										19
1088 //	        < 20 ; 38M ; MAR 2021 ; opt. ; - ; 0 ; 1,19083840952538 ; -1 ; -0,00025 ; 0,00025 ; -5,7 ; -5,6 ; 9,8 ; 9,2 ; -1,2 ; 2,9 ; 0,37 ; NABRUBMA2167 ; CA0EdfeFfc9BfF9fcb3fFD5933b96A05B47a39F0e1DC25aECcdAD8CFa3CbD5Ea ; < oPW1dBufssq1LUnK1H84Dv828NhEAL0rAt8v8ts04JW54c3ysoJ8DyeMv1f8Y448 > >										20
1089 //	        < 21 ; 40M ; MAY 2021 ; opt. ; - ; 0 ; 1,19602939408026 ; -1 ; -0,00025 ; 0,00025 ; -3,5 ; -1,2 ; 8,6 ; -4 ; -2,8 ; -6,4 ; 0,11 ; NABRUBMA2126 ; fed12aCDf4Eeaae8AEfDBa498BCe5f5baAd3eF44bf33D0Abc8D3BeD967D25deE ; < nk0s72aab4KU8NxP5Di57dVNb9b90y6Iltu7bj0X5SUhH9543w3B6ks4y9xASA1E > >										21
1090 //	        < 22 ; 42M ; JUL 2021 ; opt. ; - ; 0 ; 1,20145710341736 ; -1 ; -0,00025 ; 0,00025 ; 0,7 ; -0,8 ; 3,7 ; 8,4 ; -8,9 ; 2,2 ; -0,79 ; NABRUBJU2125 ; 77F7eFDBcabDaaD4d47Ca1d5da3dfAdD26B9C6bbebB7cEEcfaE917b3a5eaFBa1 ; < LtH7xCdIyURViVW1QB5c0jM67xJ9GmU7RdL2kSeN9I3059M2g999uz4Q0mUK52ru > >										22
1091 //	        < 23 ; 44M ; SEP 2021 ; opt. ; - ; 0 ; 1,20718583919927 ; -1 ; -0,00025 ; 0,00025 ; 5,1 ; 8,3 ; -6,2 ; -5,9 ; -6,2 ; -2 ; 0,29 ; NABRUBSE2153 ; 56Caec1C2AFb5EeAe0bc1dcCb29DeFaDbdca32e78CCDACFDc67Bb85FAB4CBd3c ; < bcwt1s84AvUCro481ue580G4BRA7eDjzCQ4vl4F9B12o0C3cNuKybCTJ5FN4sBv6 > >										23
1092 //	        < 24 ; 47M ; DEC 2021 ; opt. ; - ; 0 ; 1,2131689540148 ; -1 ; -0,00025 ; 0,00025 ; 3,4 ; 1,7 ; 1,2 ; 6,9 ; 0,8 ; 7,7 ; 0,13 ; NABRUBDE2192 ; 2dCd740eDfCbDDCebc3CAdcc1dC59d7CE9dDF1A0CDbDcfc6Ab0BCd0DeC8a66EB ; < 4163pB13V4HV45KXfbli104pe8wp038Ug7CC8Lrz8R7GxuQPyDR16Cm1p9Td6nge > >										24
1093 											
1094 //	  < CALLS ; 12M ; Strike ; Symbol ; Last ; T(-1) ; Change ; Volume ; BAS_1 ; BAS_2 ; o.i. @ eth_hex ; @ btc_882 >										
1095 											
1096 //	#DIV/0 !										1
1097 //	#DIV/0 !										2
1098 //	#DIV/0 !										3
1099 //	#DIV/0 !										4
1100 //	#DIV/0 !										5
1101 //	#DIV/0 !										6
1102 //	#DIV/0 !										7
1103 //	#DIV/0 !										8
1104 //	#DIV/0 !										9
1105 //	#DIV/0 !										10
1106 //	#DIV/0 !										11
1107 //	#DIV/0 !										12
1108 //	#DIV/0 !										13
1109 //	#DIV/0 !										14
1110 //	#DIV/0 !										15
1111 //	#DIV/0 !										16
1112 //	#DIV/0 !										17
1113 //	#DIV/0 !										18
1114 //	#DIV/0 !										19
1115 //	#DIV/0 !										20
1116 //	#DIV/0 !										21
1117 //											
1118 //	  < PUTS ; 12M ; Strike ; Symbol ; Last ; T(-1) ; Change ; Volume ; BAS_1 ; BAS_2 ; o.i. @ eth_hex ; @ btc_882 >										
1119 //											
1120 //	#DIV/0 !										1
1121 //	#DIV/0 !										2
1122 //	#DIV/0 !										3
1123 //	#DIV/0 !										4
1124 //	#DIV/0 !										5
1125 //	#DIV/0 !										6
1126 //	#DIV/0 !										7
1127 //	#DIV/0 !										8
1128 //	#DIV/0 !										9
1129 //	#DIV/0 !										10
1130 //	#DIV/0 !										11
1131 //	#DIV/0 !										12
1132 //	#DIV/0 !										13
1133 //	#DIV/0 !										14
1134 //	#DIV/0 !										15
1135 //	#DIV/0 !										16
1136 //	#DIV/0 !										17
1137 //	#DIV/0 !										18
1138 //	#DIV/0 !										19
1139 //	#DIV/0 !										20
1140 //	#DIV/0 !										21
1141 											
1142 											
1143 											
1144 											
1145 											
1146 //	NABRUB										
1147 											
1148 //	  < # ; REF ; Month ; Optionchain ; Chart ; Last ; T(-1) ; Change ; BAS_1 ; BAS_2 ; Prior. Settle ; Open ; High ; Low ; Volume ; Hi / Lo ; Updated (s) ; Code ; @ eth_hex ; @ btc_882 >										
1149 											
1150 //	        < 0 ; T0 ; - ; - ; - ; 0 ; 1,14 ; -1 ; - ; - ; - ; - ; - ; - ; - ; - ; - ; - ; FacEfABEc15492BA55AcaaAece7CFEE2CC5E36aabdCEDfD809e0FFe7BfDBA9Ad ; < zot500hG0Lxr6CaU30Mrg84xyiCd77v86G15eM2F1hV5cptLQ1Pzs9pcW497982h > >										0
1151 //	        < 1 ; 0M ; JAN 2019 ; opt. ; - ; 0 ; 1,14021100829845 ; -1 ; -0,00025 ; 0,00025 ; 8,6 ; 6,1 ; -4 ; -7,1 ; -8,9 ; 3,3 ; -0,11 ; NABRUB16JA19 ; AeC73b4d6aF50E8dDff5FA9C4CF47DFfEA6F4E260ab6B8FeB7Abcb5BEd2ae115 ; < DZT5fnz4H0nbk5Vz6rqL9RqHdxehf75R445fQ86rmCZ2wI64AdkzcO51Ft17tK15 > >										1
1152 //	        < 2 ; 2M ; MAR 2019 ; opt. ; - ; 0 ; 1,14072893010838 ; -1 ; -0,00025 ; 0,00025 ; 0,3 ; -8,6 ; 7,9 ; -3,8 ; 0,9 ; 7,1 ; -0,41 ; NABRUBMA1976 ; aE2504D6dEBaA32D1be7DD23ADAC7a2fb9F6ddF7c1EBcc7d8f54fff9dC4DCe2E ; < Rm340ZMA35919KNYf9t3A0WkLX8fi31q94207B14wVLcH49FyGT8MHQ77gH3KzY9 > >										2
1153 //	        < 3 ; 4M ; MAY 2019 ; opt. ; - ; 0 ; 1,14151878783416 ; -1 ; -0,00025 ; 0,00025 ; 8,3 ; -7,9 ; 2,2 ; 1,7 ; -8,7 ; 7,3 ; -0,08 ; NABRUBMA1940 ; d65BbBc2a1AD5afD3ceCA65FB4E542fFE47e9C5366EeDb9Adfd9Ed82e47CAc3B ; < 5I13m5QQ8N8cy51KESaR2mDL5I55wo7T8x2tmIHO70Lt4M5cdYci2F3n0D3np6us > >										3
1154 //	        < 4 ; 6M ; JUL 2019 ; opt. ; - ; 0 ; 1,14245213908666 ; -1 ; -0,00025 ; 0,00025 ; 4,2 ; -9,6 ; 6,2 ; -7 ; 8,3 ; 5,2 ; 0,61 ; NABRUBJU1923 ; e4BeEeB3Fb0cadf0cA9311E1b1BeACEc4Ff04Ea1FD3c5b92fd5DEfdDec5B7FDE ; < VMWd2947ZETt9W1f31A43IWr0qi36mVZD56K48zeY1hpiP5Dk2mGchzQqhgm2Ajp > >										4
1155 //	        < 5 ; 8M ; SEP 2019 ; opt. ; - ; 0 ; 1,14356135514363 ; -1 ; -0,00025 ; 0,00025 ; -9,2 ; 9,7 ; -7,1 ; 4,2 ; 1,5 ; -8,1 ; -0,26 ; NABRUBSE1913 ; CFEC2EEcBbBb1DeeafCCFb15df5DE5F3AaeEfc23EAAc7796AbCafccccfB295Cb ; < k4BQNMe0S3z5vvHgc603VOkVjazfJUb1MHjve82ZCydzJQ9thHcLJH8QrfxXlByE > >										5
1156 //	        < 6 ; 11M ; DEC 2019 ; opt. ; - ; 0 ; 1,14493273647751 ; -1 ; -0,00025 ; 0,00025 ; 6 ; 6,6 ; -4,7 ; -9,4 ; -4,2 ; 2,2 ; 0,83 ; NABRUBDE1952 ; eCDF1efbEd9A5dCAe31Dd6caEaC1291afaFBDD5eA47e5f04CC8dd6ffDAcFFfBD ; < igVHHCiciMhdR50Ua5qBQ8P78wR7J7kKSziAQP86MRJN7gaYs71rny9KLmWsq37R > >										6
1157 //	        < 7 ; 12M ; JAN 2020 ; opt. ; - ; 0 ; 1,14658324252079 ; -1 ; -0,00025 ; 0,00025 ; 5,7 ; 9,6 ; 3,4 ; -9,9 ; 4,1 ; -2,5 ; -0,1 ; NABRUBJA2012 ; 3Ca0fdDEac1F7F27fD60Fb9bEdbac27Ac5fDAF1fdccAddCEfDbD63eFACd9f2bB ; < 29wt3xp2Fzi16Zl4TCm58t1w9v2C0KSPaC6KviMj0C8qddG8gQs3Rl9823OlDA9G > >										7
1158 //	        < 8 ; 14M ; MAR 2020 ; opt. ; - ; 0 ; 1,14843838324108 ; -1 ; -0,00025 ; 0,00025 ; 0,7 ; 2,9 ; -0,6 ; -4,8 ; -8,3 ; 3,9 ; 0,85 ; NABRUBMA2085 ; bC1ACb5893DDdebAcFEB84a5Cfcc413BB5fa0B4FCAC5A1E1fc11a785f5fBB149 ; < SVgPlpQnc3lqwvsP2TdFTFY1f1isAZ3K4DiD65V0q7F71kzttFSqoC8v759lwOTf > >										8
1159 //	        < 9 ; 16M ; MAY 2020 ; opt. ; - ; 0 ; 1,15053935326926 ; -1 ; -0,00025 ; 0,00025 ; 9,3 ; -0,2 ; -8,6 ; -5,2 ; 9 ; 4,1 ; -0,27 ; NABRUBMA2035 ; baABbCFB0bb7dbEc031Dd2231dddBAdcA35a7EDe2EeAB6beB6103641742DAded ; < ZEmHKXKs6JkkHxpf32m23aIdB8hhFnB9T9ns2RN2hfhp1F271oGGtWjhD26kE2ZW > >										9
1160 //	        < 10 ; 18M ; JUL 2020 ; opt. ; - ; 0 ; 1,15296572539722 ; -1 ; -0,00025 ; 0,00025 ; -1,8 ; -3,8 ; -8,6 ; -1 ; 0,1 ; 8 ; -0,96 ; NABRUBJU2011 ; aAb2e5CBB2EBC4Dc375ed38eAb0ee3afF7eFbecE8B9bBdB53bcdd60fc1Fb999D ; < vO5dKp8162w054gagf5R50YKz1vBf0g1Sd3910qrKJ40W7mLJflcawmoUEAigO4N > >										10
1161 //	        < 11 ; 20M ; SEP 2020 ; opt. ; - ; 0 ; 1,15565954699318 ; -1 ; -0,00025 ; 0,00025 ; 1,5 ; -2 ; 0,7 ; -8,2 ; 4,3 ; 5,9 ; -0,84 ; NABRUBSE2069 ; 35204BA3dA8888fB4B8D0Fc4781acBCc6da2EA49a4cb28afaAE870fe5d7C8F29 ; < qbOynA06C6B4qyx39EEA1wIzGL05coHP440B5Q6EI7Z48PT67Fq9a71oZ450YEfD > >										11
1162 //	        < 12 ; 23M ; DEC 2020 ; opt. ; - ; 0 ; 1,15855331849885 ; -1 ; -0,00025 ; 0,00025 ; 4,3 ; 8 ; 2,6 ; -7,6 ; -0,9 ; 0,5 ; 0,07 ; NABRUBDE2078 ; CAebaDb4dcdbCFF7FcDA0CeBeBECa9C99ecBff3A32d962AA2ddbed33db3ebBd4 ; < BXbdOqwTNHLyvX62957Wn6W42f6bn8120Q91NP658dzt24K2gmA38CU8jwL3kIJS > >										12
1163 //	        < 13 ; 24M ; JAN 2021 ; opt. ; - ; 0 ; 1,16159986795705 ; -1 ; -0,00025 ; 0,00025 ; -3,6 ; -1,4 ; -1 ; 9,4 ; -8,8 ; 3 ; -0,45 ; NABRUBJA2157 ; 680d53DD08F71cCa7cd51BD4D3Ca3dB9ECCDCDeCACE1FC4abDbDDca67ab356D3 ; < HVmd5OQan6tSo3Yb9jL2VmCa6mjqg13cLHD5z4C8mZoBPV4366uEjK5ZgRWq7sU9 > >										13
1164 //	        < 14 ; 26M ; MAR 2021 ; opt. ; - ; 0 ; 1,16501064331307 ; -1 ; -0,00025 ; 0,00025 ; 4,5 ; 4,9 ; 1,5 ; -7,9 ; 6,6 ; -7,4 ; 0,63 ; NABRUBMA2166 ; eaecB6cc7bEaDeE0fa3EA59E7d749Febb7fBCc8dc8d35AC36ea9DC21b280Ce9c ; < YcLj0dW1VZ74YLkcgsE3Uy9fxccQ1Izl4dDDUbQ5hz5yXOtCfR60Y8122t3GaynJ > >										14
1165 //	        < 15 ; 28M ; MAY 2021 ; opt. ; - ; 0 ; 1,16875029946288 ; -1 ; -0,00025 ; 0,00025 ; -5,4 ; 8,3 ; -9,3 ; -0,9 ; -4,3 ; 6 ; -0,58 ; NABRUBMA2128 ; 15D1Fe7ABa8FC895db3FA2f31b5BAbbcEAE674F27ADBA19Be8D8aEEDFBdFF90b ; < 5aqMyQWVoLv900r5N037trOp17KH50PQiu6W9EC5Hi9OcOn44awxXS5s86CAUg4t > >										15
1166 //	        < 16 ; 30M ; JUL 2021 ; opt. ; - ; 0 ; 1,1725413998806 ; -1 ; -0,00025 ; 0,00025 ; -1,9 ; 3,6 ; 8,8 ; -8,4 ; 4,4 ; 6,1 ; -0,87 ; NABRUBJU2148 ; 8Eb2ACdfAeCC073F22abc3B1cCDfBa6308B7b0bF35Bf39CeA0FEA13DfEBeDBE8 ; < d7Vn70PFeob92XFfj4Niv4lk1NslUYvq0BTiZRmIo1qIkz9m45l3287X5svZRrg0 > >										16
1167 //	        < 17 ; 32M ; SEP 2021 ; opt. ; - ; 0 ; 1,17673383383731 ; -1 ; -0,00025 ; 0,00025 ; 8,5 ; -3,6 ; -6,9 ; -2,8 ; -8,3 ; 2,1 ; -0,27 ; NABRUBSE2130 ; Dfb4BdbcFdEdBfa64a7a9eAc5CCDaB2Fd81aBdb6eF6a06A036a8C3Cc9deE6fa5 ; < iJz57Xy6tDW9SWtNhfZz25O8m6SeLB7KQkc7g3o1c3Hin3eOR02J22P9w7I514tz > >										17
1168 //	        < 18 ; 35M ; DEC 2021 ; opt. ; - ; 0 ; 1,18115875640671 ; -1 ; -0,00025 ; 0,00025 ; 9,2 ; 3,3 ; -9,1 ; -6 ; 9,6 ; -7 ; -0,12 ; NABRUBDE2186 ; bbCe5A14250fDDaEA1F5EbBB2c76fcB3eba2cAf7A6AC2bD4CAFDcDBfeCb7DFb4 ; < FtI34q79Co8NT14DTEt19FmYxfmtff3Yr666YHsqcnMh544Xa54qqBF6Ufj2iNVT > >										18
1169 //	        < 19 ; 36M ; JAN 2021 ; opt. ; - ; 0 ; 1,18578561347666 ; -1 ; -0,00025 ; 0,00025 ; 9,6 ; 6,8 ; 2 ; -9,6 ; 5,1 ; -6,2 ; 0,03 ; NABRUBJA2172 ; D4B5FeAbd5Bf6635efc2dfccbD12CEdBEE03Aecb8bAc2ebDaEa92CeB3aDdb67A ; < k38v0At8YIbjAXbO0h8XIsHa2QVT8P41QJVuS074bUll2182SUu6mgg1EzxB8YoF > >										19
1170 //	        < 20 ; 38M ; MAR 2021 ; opt. ; - ; 0 ; 1,19083840952538 ; -1 ; -0,00025 ; 0,00025 ; -5,7 ; -5,6 ; 9,8 ; 9,2 ; -1,2 ; 2,9 ; 0,37 ; NABRUBMA2167 ; CA0EdfeFfc9BfF9fcb3fFD5933b96A05B47a39F0e1DC25aECcdAD8CFa3CbD5Ea ; < oPW1dBufssq1LUnK1H84Dv828NhEAL0rAt8v8ts04JW54c3ysoJ8DyeMv1f8Y448 > >										20
1171 //	        < 21 ; 40M ; MAY 2021 ; opt. ; - ; 0 ; 1,19602939408026 ; -1 ; -0,00025 ; 0,00025 ; -3,5 ; -1,2 ; 8,6 ; -4 ; -2,8 ; -6,4 ; 0,11 ; NABRUBMA2126 ; fed12aCDf4Eeaae8AEfDBa498BCe5f5baAd3eF44bf33D0Abc8D3BeD967D25deE ; < nk0s72aab4KU8NxP5Di57dVNb9b90y6Iltu7bj0X5SUhH9543w3B6ks4y9xASA1E > >										21
1172 //	        < 22 ; 42M ; JUL 2021 ; opt. ; - ; 0 ; 1,20145710341736 ; -1 ; -0,00025 ; 0,00025 ; 0,7 ; -0,8 ; 3,7 ; 8,4 ; -8,9 ; 2,2 ; -0,79 ; NABRUBJU2125 ; 77F7eFDBcabDaaD4d47Ca1d5da3dfAdD26B9C6bbebB7cEEcfaE917b3a5eaFBa1 ; < LtH7xCdIyURViVW1QB5c0jM67xJ9GmU7RdL2kSeN9I3059M2g999uz4Q0mUK52ru > >										22
1173 //	        < 23 ; 44M ; SEP 2021 ; opt. ; - ; 0 ; 1,20718583919927 ; -1 ; -0,00025 ; 0,00025 ; 5,1 ; 8,3 ; -6,2 ; -5,9 ; -6,2 ; -2 ; 0,29 ; NABRUBSE2153 ; 56Caec1C2AFb5EeAe0bc1dcCb29DeFaDbdca32e78CCDACFDc67Bb85FAB4CBd3c ; < bcwt1s84AvUCro481ue580G4BRA7eDjzCQ4vl4F9B12o0C3cNuKybCTJ5FN4sBv6 > >										23
1174 //	        < 24 ; 47M ; DEC 2021 ; opt. ; - ; 0 ; 1,2131689540148 ; -1 ; -0,00025 ; 0,00025 ; 3,4 ; 1,7 ; 1,2 ; 6,9 ; 0,8 ; 7,7 ; 0,13 ; NABRUBDE2192 ; 2dCd740eDfCbDDCebc3CAdcc1dC59d7CE9dDF1A0CDbDcfc6Ab0BCd0DeC8a66EB ; < 4163pB13V4HV45KXfbli104pe8wp038Ug7CC8Lrz8R7GxuQPyDR16Cm1p9Td6nge > >										24
1175 											
1176 //	  < CALLS ; 24M ; Strike ; Symbol ; Last ; T(-1) ; Change ; Volume ; BAS_1 ; BAS_2 ; o.i. @ eth_hex ; @ btc_882 >										
1177 											
1178 //	#DIV/0 !										1
1179 //	#DIV/0 !										2
1180 //	#DIV/0 !										3
1181 //	#DIV/0 !										4
1182 //	#DIV/0 !										5
1183 //	#DIV/0 !										6
1184 //	#DIV/0 !										7
1185 //	#DIV/0 !										8
1186 //	#DIV/0 !										9
1187 //	#DIV/0 !										10
1188 //	#DIV/0 !										11
1189 //	#DIV/0 !										12
1190 //	#DIV/0 !										13
1191 //	#DIV/0 !										14
1192 //	#DIV/0 !										15
1193 //	#DIV/0 !										16
1194 //	#DIV/0 !										17
1195 //	#DIV/0 !										18
1196 //	#DIV/0 !										19
1197 //	#DIV/0 !										20
1198 //	#DIV/0 !										21
1199 //											
1200 //	  < PUTS ; 24M ; Strike ; Symbol ; Last ; T(-1) ; Change ; Volume ; BAS_1 ; BAS_2 ; o.i. @ eth_hex ; @ btc_882 >										
1201 //											
1202 //	#DIV/0 !										1
1203 //	#DIV/0 !										2
1204 //	#DIV/0 !										3
1205 //	#DIV/0 !										4
1206 //	#DIV/0 !										5
1207 //	#DIV/0 !										6
1208 //	#DIV/0 !										7
1209 //	#DIV/0 !										8
1210 //	#DIV/0 !										9
1211 //	#DIV/0 !										10
1212 //	#DIV/0 !										11
1213 //	#DIV/0 !										12
1214 //	#DIV/0 !										13
1215 //	#DIV/0 !										14
1216 //	#DIV/0 !										15
1217 //	#DIV/0 !										16
1218 //	#DIV/0 !										17
1219 //	#DIV/0 !										18
1220 //	#DIV/0 !										19
1221 //	#DIV/0 !										20
1222 //	#DIV/0 !										21
1223 											
1224 											
1225 											
1226 											
1227 											
1228 //	NABRUB										
1229 											
1230 //	  < # ; REF ; Month ; Optionchain ; Chart ; Last ; T(-1) ; Change ; BAS_1 ; BAS_2 ; Prior. Settle ; Open ; High ; Low ; Volume ; Hi / Lo ; Updated (s) ; Code ; @ eth_hex ; @ btc_882 >										
1231 											
1232 //	        < 0 ; T0 ; - ; - ; - ; 0 ; 1,14 ; -1 ; - ; - ; - ; - ; - ; - ; - ; - ; - ; - ; FacEfABEc15492BA55AcaaAece7CFEE2CC5E36aabdCEDfD809e0FFe7BfDBA9Ad ; < zot500hG0Lxr6CaU30Mrg84xyiCd77v86G15eM2F1hV5cptLQ1Pzs9pcW497982h > >										0
1233 //	        < 1 ; 0M ; JAN 2019 ; opt. ; - ; 0 ; 1,14021100829845 ; -1 ; -0,00025 ; 0,00025 ; 8,6 ; 6,1 ; -4 ; -7,1 ; -8,9 ; 3,3 ; -0,11 ; NABRUB16JA19 ; AeC73b4d6aF50E8dDff5FA9C4CF47DFfEA6F4E260ab6B8FeB7Abcb5BEd2ae115 ; < DZT5fnz4H0nbk5Vz6rqL9RqHdxehf75R445fQ86rmCZ2wI64AdkzcO51Ft17tK15 > >										1
1234 //	        < 2 ; 2M ; MAR 2019 ; opt. ; - ; 0 ; 1,14072893010838 ; -1 ; -0,00025 ; 0,00025 ; 0,3 ; -8,6 ; 7,9 ; -3,8 ; 0,9 ; 7,1 ; -0,41 ; NABRUBMA1976 ; aE2504D6dEBaA32D1be7DD23ADAC7a2fb9F6ddF7c1EBcc7d8f54fff9dC4DCe2E ; < Rm340ZMA35919KNYf9t3A0WkLX8fi31q94207B14wVLcH49FyGT8MHQ77gH3KzY9 > >										2
1235 //	        < 3 ; 4M ; MAY 2019 ; opt. ; - ; 0 ; 1,14151878783416 ; -1 ; -0,00025 ; 0,00025 ; 8,3 ; -7,9 ; 2,2 ; 1,7 ; -8,7 ; 7,3 ; -0,08 ; NABRUBMA1940 ; d65BbBc2a1AD5afD3ceCA65FB4E542fFE47e9C5366EeDb9Adfd9Ed82e47CAc3B ; < 5I13m5QQ8N8cy51KESaR2mDL5I55wo7T8x2tmIHO70Lt4M5cdYci2F3n0D3np6us > >										3
1236 //	        < 4 ; 6M ; JUL 2019 ; opt. ; - ; 0 ; 1,14245213908666 ; -1 ; -0,00025 ; 0,00025 ; 4,2 ; -9,6 ; 6,2 ; -7 ; 8,3 ; 5,2 ; 0,61 ; NABRUBJU1923 ; e4BeEeB3Fb0cadf0cA9311E1b1BeACEc4Ff04Ea1FD3c5b92fd5DEfdDec5B7FDE ; < VMWd2947ZETt9W1f31A43IWr0qi36mVZD56K48zeY1hpiP5Dk2mGchzQqhgm2Ajp > >										4
1237 //	        < 5 ; 8M ; SEP 2019 ; opt. ; - ; 0 ; 1,14356135514363 ; -1 ; -0,00025 ; 0,00025 ; -9,2 ; 9,7 ; -7,1 ; 4,2 ; 1,5 ; -8,1 ; -0,26 ; NABRUBSE1913 ; CFEC2EEcBbBb1DeeafCCFb15df5DE5F3AaeEfc23EAAc7796AbCafccccfB295Cb ; < k4BQNMe0S3z5vvHgc603VOkVjazfJUb1MHjve82ZCydzJQ9thHcLJH8QrfxXlByE > >										5
1238 //	        < 6 ; 11M ; DEC 2019 ; opt. ; - ; 0 ; 1,14493273647751 ; -1 ; -0,00025 ; 0,00025 ; 6 ; 6,6 ; -4,7 ; -9,4 ; -4,2 ; 2,2 ; 0,83 ; NABRUBDE1952 ; eCDF1efbEd9A5dCAe31Dd6caEaC1291afaFBDD5eA47e5f04CC8dd6ffDAcFFfBD ; < igVHHCiciMhdR50Ua5qBQ8P78wR7J7kKSziAQP86MRJN7gaYs71rny9KLmWsq37R > >										6
1239 //	        < 7 ; 12M ; JAN 2020 ; opt. ; - ; 0 ; 1,14658324252079 ; -1 ; -0,00025 ; 0,00025 ; 5,7 ; 9,6 ; 3,4 ; -9,9 ; 4,1 ; -2,5 ; -0,1 ; NABRUBJA2012 ; 3Ca0fdDEac1F7F27fD60Fb9bEdbac27Ac5fDAF1fdccAddCEfDbD63eFACd9f2bB ; < 29wt3xp2Fzi16Zl4TCm58t1w9v2C0KSPaC6KviMj0C8qddG8gQs3Rl9823OlDA9G > >										7
1240 //	        < 8 ; 14M ; MAR 2020 ; opt. ; - ; 0 ; 1,14843838324108 ; -1 ; -0,00025 ; 0,00025 ; 0,7 ; 2,9 ; -0,6 ; -4,8 ; -8,3 ; 3,9 ; 0,85 ; NABRUBMA2085 ; bC1ACb5893DDdebAcFEB84a5Cfcc413BB5fa0B4FCAC5A1E1fc11a785f5fBB149 ; < SVgPlpQnc3lqwvsP2TdFTFY1f1isAZ3K4DiD65V0q7F71kzttFSqoC8v759lwOTf > >										8
1241 //	        < 9 ; 16M ; MAY 2020 ; opt. ; - ; 0 ; 1,15053935326926 ; -1 ; -0,00025 ; 0,00025 ; 9,3 ; -0,2 ; -8,6 ; -5,2 ; 9 ; 4,1 ; -0,27 ; NABRUBMA2035 ; baABbCFB0bb7dbEc031Dd2231dddBAdcA35a7EDe2EeAB6beB6103641742DAded ; < ZEmHKXKs6JkkHxpf32m23aIdB8hhFnB9T9ns2RN2hfhp1F271oGGtWjhD26kE2ZW > >										9
1242 //	        < 10 ; 18M ; JUL 2020 ; opt. ; - ; 0 ; 1,15296572539722 ; -1 ; -0,00025 ; 0,00025 ; -1,8 ; -3,8 ; -8,6 ; -1 ; 0,1 ; 8 ; -0,96 ; NABRUBJU2011 ; aAb2e5CBB2EBC4Dc375ed38eAb0ee3afF7eFbecE8B9bBdB53bcdd60fc1Fb999D ; < vO5dKp8162w054gagf5R50YKz1vBf0g1Sd3910qrKJ40W7mLJflcawmoUEAigO4N > >										10
1243 //	        < 11 ; 20M ; SEP 2020 ; opt. ; - ; 0 ; 1,15565954699318 ; -1 ; -0,00025 ; 0,00025 ; 1,5 ; -2 ; 0,7 ; -8,2 ; 4,3 ; 5,9 ; -0,84 ; NABRUBSE2069 ; 35204BA3dA8888fB4B8D0Fc4781acBCc6da2EA49a4cb28afaAE870fe5d7C8F29 ; < qbOynA06C6B4qyx39EEA1wIzGL05coHP440B5Q6EI7Z48PT67Fq9a71oZ450YEfD > >										11
1244 //	        < 12 ; 23M ; DEC 2020 ; opt. ; - ; 0 ; 1,15855331849885 ; -1 ; -0,00025 ; 0,00025 ; 4,3 ; 8 ; 2,6 ; -7,6 ; -0,9 ; 0,5 ; 0,07 ; NABRUBDE2078 ; CAebaDb4dcdbCFF7FcDA0CeBeBECa9C99ecBff3A32d962AA2ddbed33db3ebBd4 ; < BXbdOqwTNHLyvX62957Wn6W42f6bn8120Q91NP658dzt24K2gmA38CU8jwL3kIJS > >										12
1245 //	        < 13 ; 24M ; JAN 2021 ; opt. ; - ; 0 ; 1,16159986795705 ; -1 ; -0,00025 ; 0,00025 ; -3,6 ; -1,4 ; -1 ; 9,4 ; -8,8 ; 3 ; -0,45 ; NABRUBJA2157 ; 680d53DD08F71cCa7cd51BD4D3Ca3dB9ECCDCDeCACE1FC4abDbDDca67ab356D3 ; < HVmd5OQan6tSo3Yb9jL2VmCa6mjqg13cLHD5z4C8mZoBPV4366uEjK5ZgRWq7sU9 > >										13
1246 //	        < 14 ; 26M ; MAR 2021 ; opt. ; - ; 0 ; 1,16501064331307 ; -1 ; -0,00025 ; 0,00025 ; 4,5 ; 4,9 ; 1,5 ; -7,9 ; 6,6 ; -7,4 ; 0,63 ; NABRUBMA2166 ; eaecB6cc7bEaDeE0fa3EA59E7d749Febb7fBCc8dc8d35AC36ea9DC21b280Ce9c ; < YcLj0dW1VZ74YLkcgsE3Uy9fxccQ1Izl4dDDUbQ5hz5yXOtCfR60Y8122t3GaynJ > >										14
1247 //	        < 15 ; 28M ; MAY 2021 ; opt. ; - ; 0 ; 1,16875029946288 ; -1 ; -0,00025 ; 0,00025 ; -5,4 ; 8,3 ; -9,3 ; -0,9 ; -4,3 ; 6 ; -0,58 ; NABRUBMA2128 ; 15D1Fe7ABa8FC895db3FA2f31b5BAbbcEAE674F27ADBA19Be8D8aEEDFBdFF90b ; < 5aqMyQWVoLv900r5N037trOp17KH50PQiu6W9EC5Hi9OcOn44awxXS5s86CAUg4t > >										15
1248 //	        < 16 ; 30M ; JUL 2021 ; opt. ; - ; 0 ; 1,1725413998806 ; -1 ; -0,00025 ; 0,00025 ; -1,9 ; 3,6 ; 8,8 ; -8,4 ; 4,4 ; 6,1 ; -0,87 ; NABRUBJU2148 ; 8Eb2ACdfAeCC073F22abc3B1cCDfBa6308B7b0bF35Bf39CeA0FEA13DfEBeDBE8 ; < d7Vn70PFeob92XFfj4Niv4lk1NslUYvq0BTiZRmIo1qIkz9m45l3287X5svZRrg0 > >										16
1249 //	        < 17 ; 32M ; SEP 2021 ; opt. ; - ; 0 ; 1,17673383383731 ; -1 ; -0,00025 ; 0,00025 ; 8,5 ; -3,6 ; -6,9 ; -2,8 ; -8,3 ; 2,1 ; -0,27 ; NABRUBSE2130 ; Dfb4BdbcFdEdBfa64a7a9eAc5CCDaB2Fd81aBdb6eF6a06A036a8C3Cc9deE6fa5 ; < iJz57Xy6tDW9SWtNhfZz25O8m6SeLB7KQkc7g3o1c3Hin3eOR02J22P9w7I514tz > >										17
1250 //	        < 18 ; 35M ; DEC 2021 ; opt. ; - ; 0 ; 1,18115875640671 ; -1 ; -0,00025 ; 0,00025 ; 9,2 ; 3,3 ; -9,1 ; -6 ; 9,6 ; -7 ; -0,12 ; NABRUBDE2186 ; bbCe5A14250fDDaEA1F5EbBB2c76fcB3eba2cAf7A6AC2bD4CAFDcDBfeCb7DFb4 ; < FtI34q79Co8NT14DTEt19FmYxfmtff3Yr666YHsqcnMh544Xa54qqBF6Ufj2iNVT > >										18
1251 //	        < 19 ; 36M ; JAN 2021 ; opt. ; - ; 0 ; 1,18578561347666 ; -1 ; -0,00025 ; 0,00025 ; 9,6 ; 6,8 ; 2 ; -9,6 ; 5,1 ; -6,2 ; 0,03 ; NABRUBJA2172 ; D4B5FeAbd5Bf6635efc2dfccbD12CEdBEE03Aecb8bAc2ebDaEa92CeB3aDdb67A ; < k38v0At8YIbjAXbO0h8XIsHa2QVT8P41QJVuS074bUll2182SUu6mgg1EzxB8YoF > >										19
1252 //	        < 20 ; 38M ; MAR 2021 ; opt. ; - ; 0 ; 1,19083840952538 ; -1 ; -0,00025 ; 0,00025 ; -5,7 ; -5,6 ; 9,8 ; 9,2 ; -1,2 ; 2,9 ; 0,37 ; NABRUBMA2167 ; CA0EdfeFfc9BfF9fcb3fFD5933b96A05B47a39F0e1DC25aECcdAD8CFa3CbD5Ea ; < oPW1dBufssq1LUnK1H84Dv828NhEAL0rAt8v8ts04JW54c3ysoJ8DyeMv1f8Y448 > >										20
1253 //	        < 21 ; 40M ; MAY 2021 ; opt. ; - ; 0 ; 1,19602939408026 ; -1 ; -0,00025 ; 0,00025 ; -3,5 ; -1,2 ; 8,6 ; -4 ; -2,8 ; -6,4 ; 0,11 ; NABRUBMA2126 ; fed12aCDf4Eeaae8AEfDBa498BCe5f5baAd3eF44bf33D0Abc8D3BeD967D25deE ; < nk0s72aab4KU8NxP5Di57dVNb9b90y6Iltu7bj0X5SUhH9543w3B6ks4y9xASA1E > >										21
1254 //	        < 22 ; 42M ; JUL 2021 ; opt. ; - ; 0 ; 1,20145710341736 ; -1 ; -0,00025 ; 0,00025 ; 0,7 ; -0,8 ; 3,7 ; 8,4 ; -8,9 ; 2,2 ; -0,79 ; NABRUBJU2125 ; 77F7eFDBcabDaaD4d47Ca1d5da3dfAdD26B9C6bbebB7cEEcfaE917b3a5eaFBa1 ; < LtH7xCdIyURViVW1QB5c0jM67xJ9GmU7RdL2kSeN9I3059M2g999uz4Q0mUK52ru > >										22
1255 //	        < 23 ; 44M ; SEP 2021 ; opt. ; - ; 0 ; 1,20718583919927 ; -1 ; -0,00025 ; 0,00025 ; 5,1 ; 8,3 ; -6,2 ; -5,9 ; -6,2 ; -2 ; 0,29 ; NABRUBSE2153 ; 56Caec1C2AFb5EeAe0bc1dcCb29DeFaDbdca32e78CCDACFDc67Bb85FAB4CBd3c ; < bcwt1s84AvUCro481ue580G4BRA7eDjzCQ4vl4F9B12o0C3cNuKybCTJ5FN4sBv6 > >										23
1256 //	        < 24 ; 47M ; DEC 2021 ; opt. ; - ; 0 ; 1,2131689540148 ; -1 ; -0,00025 ; 0,00025 ; 3,4 ; 1,7 ; 1,2 ; 6,9 ; 0,8 ; 7,7 ; 0,13 ; NABRUBDE2192 ; 2dCd740eDfCbDDCebc3CAdcc1dC59d7CE9dDF1A0CDbDcfc6Ab0BCd0DeC8a66EB ; < 4163pB13V4HV45KXfbli104pe8wp038Ug7CC8Lrz8R7GxuQPyDR16Cm1p9Td6nge > >										24
1257 											
1258 //	  < CALLS ; 36M ; Strike ; Symbol ; Last ; T(-1) ; Change ; Volume ; BAS_1 ; BAS_2 ; o.i. @ eth_hex ; @ btc_882 >										
1259 											
1260 //	#DIV/0 !										1
1261 //	#DIV/0 !										2
1262 //	#DIV/0 !										3
1263 //	#DIV/0 !										4
1264 //	#DIV/0 !										5
1265 //	#DIV/0 !										6
1266 //	#DIV/0 !										7
1267 //	#DIV/0 !										8
1268 //	#DIV/0 !										9
1269 //	#DIV/0 !										10
1270 //	#DIV/0 !										11
1271 //	#DIV/0 !										12
1272 //	#DIV/0 !										13
1273 //	#DIV/0 !										14
1274 //	#DIV/0 !										15
1275 //	#DIV/0 !										16
1276 //	#DIV/0 !										17
1277 //	#DIV/0 !										18
1278 //	#DIV/0 !										19
1279 //	#DIV/0 !										20
1280 //	#DIV/0 !										21
1281 //											
1282 //	  < PUTS ; 36M ; Strike ; Symbol ; Last ; T(-1) ; Change ; Volume ; BAS_1 ; BAS_2 ; o.i. @ eth_hex ; @ btc_882 >										
1283 //											
1284 //	#DIV/0 !										1
1285 //	#DIV/0 !										2
1286 //	#DIV/0 !										3
1287 //	#DIV/0 !										4
1288 //	#DIV/0 !										5
1289 //	#DIV/0 !										6
1290 //	#DIV/0 !										7
1291 //	#DIV/0 !										8
1292 //	#DIV/0 !										9
1293 //	#DIV/0 !										10
1294 //	#DIV/0 !										11
1295 //	#DIV/0 !										12
1296 //	#DIV/0 !										13
1297 //	#DIV/0 !										14
1298 //	#DIV/0 !										15
1299 //	#DIV/0 !										16
1300 //	#DIV/0 !										17
1301 //	#DIV/0 !										18
1302 //	#DIV/0 !										19
1303 //	#DIV/0 !										20
1304 //	#DIV/0 !										21
1305 											
1306 											
1307 											
1308 											
1309 											
1310 //	NABCNY										
1311 											
1312 //	  < # ; REF ; Month ; Optionchain ; Chart ; Last ; T(-1) ; Change ; BAS_1 ; BAS_2 ; Prior. Settle ; Open ; High ; Low ; Volume ; Hi / Lo ; Updated (s) ; Code ; @ eth_hex ; @ btc_882 >										
1313 											
1314 //	        < 0 ; T0 ; - ; - ; - ; 0 ; 1,14 ; -1 ; - ; - ; - ; - ; - ; - ; - ; - ; - ; - ; 161bF94D215ACAD73A0058eF56DEdc8a0EBE8aD3aC9b5D8C0EfCBceaf5eddde9 ; < p0lVtq04AW915sCuurd9IMo7ewAd02z5XuO8AZ899704v6BmU47xYIJZ31BIpeD1 > >										0
1315 //	        < 1 ; 0M ; JAN 2019 ; opt. ; - ; 0 ; 1,14013006829845 ; -1 ; -0,00025 ; 0,00025 ; -4,7 ; -8 ; 1,6 ; -6,4 ; -2,2 ; 5 ; -0,33 ; NABCNY63JA19 ; D5CcdeC0dBafEb4EaA8bF25E5eBB81eCAAB6eDfeecffAA9B9DEa21ddaBeBdfd0 ; < sPy4Ie2907w1OC892rVqS2b46rCkA82BauCob0qY3551nHXgfysy7SiI6qr6HPG2 > >										1
1316 //	        < 2 ; 2M ; MAR 2019 ; opt. ; - ; 0 ; 1,14050657721427 ; -1 ; -0,00025 ; 0,00025 ; -3,7 ; -9,8 ; 6 ; 9 ; 2,3 ; -6,5 ; -0,94 ; NABCNYMA1919 ; 3FE89Da5C79AcB527d3005b4EEBCEA7DE00E876D51dc6Ff4BDF2AEfD9FEFf9e5 ; < 5T6Dh67YAH7KW85Mz6xwR22dzec3AcZ4v665J8r90P2pzy5g8wdqnXL44f973f6u > >										2
1317 //	        < 3 ; 4M ; MAY 2019 ; opt. ; - ; 0 ; 1,1412403961573 ; -1 ; -0,00025 ; 0,00025 ; 6,1 ; -8,9 ; -1 ; 2,4 ; -0,8 ; -3,6 ; -0,81 ; NABCNYMA1913 ; aaaDcBCEf8d3BfCb78116D7D631aaE82DDABCCE4B9fC3d14deE0CBfafeB9d5d8 ; < lTs2X2R2l2Bnqy0mSR8Ozke60QMh85g58Syj5F8MNUT4AaHBhkoMNE1Zlozev5oI > >										3
1318 //	        < 4 ; 6M ; JUL 2019 ; opt. ; - ; 0 ; 1,14215525993933 ; -1 ; -0,00025 ; 0,00025 ; -9,4 ; -4,6 ; -3,9 ; 8,4 ; 3,9 ; 1,2 ; 0,65 ; NABCNYJU1976 ; ccCA7CEDb3E1E1E5AC4FF643b8DAf5912CaBBA70454aCEEF499Ec24DeDB6c236 ; < 432VWTUx6hi6NcQDdr9Tv41312wj0kOb192AKpje19XkypR9iH0o2oS1NzT48QCy > >										4
1319 //	        < 5 ; 8M ; SEP 2019 ; opt. ; - ; 0 ; 1,14344236397449 ; -1 ; -0,00025 ; 0,00025 ; 8,6 ; -9,9 ; 6,3 ; 1,1 ; 9,3 ; -8,5 ; -0,99 ; NABCNYSE1988 ; BaBCECC0DFaEA9ACFbE8142cFb4e0e9ce7DB5Ce1c9cF02A83eC2a8AEFfDf7f0a ; < tXm4UQlCP275o5JDzbzw7YINcn916if9ds0K29fDVYbq4Uso0SX3OhV2luF0QH5Y > >										5
1320 //	        < 6 ; 11M ; DEC 2019 ; opt. ; - ; 0 ; 1,14496911077331 ; -1 ; -0,00025 ; 0,00025 ; -6,9 ; 7,8 ; -3,2 ; -4,8 ; -3,5 ; -1,1 ; -0,37 ; NABCNYDE1951 ; ADD9EbCecA8438CcDe94BbAB1E7DAF3cFd4daab21fc9efD3abEbcA63C7BcbDb2 ; < U63652m61QS6k92NGJv4Q32MC3k2Z61t30l8RjBiX9N7Fd1jh1Rsrw6Egkbtrl42 > >										6
1321 //	        < 7 ; 12M ; JAN 2020 ; opt. ; - ; 0 ; 1,14671813659638 ; -1 ; -0,00025 ; 0,00025 ; 5,7 ; -4,2 ; 2,5 ; -2,7 ; 6,4 ; 3,7 ; 0,87 ; NABCNYJA2019 ; 1C7fB2eEcAbB127Ef51258CeDedFB9Cbe6A4a27Ff2AB32c3FEa70DC0Ff1DfAED ; < 49e0T6etNJX15426TrFIG0CDHsu8Cy9PCDLx8gv197X0M9LdmJC1xSPE78B8ao2H > >										7
1322 //	        < 8 ; 14M ; MAR 2020 ; opt. ; - ; 0 ; 1,1486789936402 ; -1 ; -0,00025 ; 0,00025 ; 2,3 ; 3 ; 8,2 ; -3,4 ; 9,2 ; -9,5 ; 0,66 ; NABCNYMA2034 ; 6DceAaECEfca15DD8FfcEbCdAD98b6fBCB0fa4Fc4dBEe6B34eBAEF2dEf1eEfDe ; < 0DUz3452QlPjWBd1G19zRAtO92C917AFOABHb5422IlwCe98W13dc9xnIt60TWeb > >										8
1323 //	        < 9 ; 16M ; MAY 2020 ; opt. ; - ; 0 ; 1,15075513290672 ; -1 ; -0,00025 ; 0,00025 ; -7 ; 6,2 ; 9,4 ; -6,4 ; -3,5 ; 0,4 ; -0,08 ; NABCNYMA2082 ; 7F0769eeCCaFae5EfA9c6a6Ef0cA5C8de1BeEE7AdCcFcebE1A247f6adad07CBa ; < PE4cFA9OIt8UU9pY0lN0Fr3RR6mJwzPG6mVe0ihL2008owKCoeWe7d22JLH1Jhj1 > >										9
1324 //	        < 10 ; 18M ; JUL 2020 ; opt. ; - ; 0 ; 1,15323719633868 ; -1 ; -0,00025 ; 0,00025 ; -3,2 ; 0,4 ; -1,5 ; -1,1 ; 3,2 ; -5,3 ; 0,98 ; NABCNYJU2013 ; ACCDCc2deeCC4bC7DDCdB8FbbD961E44bF3bBcE5ddAC7eEeE19AAdCf0fA413EE ; < rD22agS9q4IU2FbPL6YDE6L70AoKTOybcW3bcTA4MM25Em34cfnv9RAR0BR422XB > >										10
1325 //	        < 11 ; 20M ; SEP 2020 ; opt. ; - ; 0 ; 1,15592473278381 ; -1 ; -0,00025 ; 0,00025 ; 4,6 ; -9,9 ; 4,7 ; -9,7 ; -0,5 ; -9,5 ; 0,51 ; NABCNYSE2084 ; Aa37CbE4aCAc30B2614FeDcC3Fc75423eF99b8eDC0A53DcdcC6AddfABE8A8725 ; < 683lRCz8K4tn2P0G1adTNZ03e1T15V4W97UJtS87s2CY122M2e40K2w1pMUPnt6B > >										11
1326 //	        < 12 ; 23M ; DEC 2020 ; opt. ; - ; 0 ; 1,15882725978783 ; -1 ; -0,00025 ; 0,00025 ; 8,3 ; 7,8 ; -2,4 ; 9,9 ; 8,8 ; 9,1 ; -0,16 ; NABCNYDE2024 ; CfCFd78c988Cb402f6aFc0BdfeAACDabFAc8CbcadAbac6aDdAB32cABFC12eBFE ; < 3wV37G6b0yfQXP7hoOEEE94u14i7Q1t4qnRMpXqar0ACTup0F9m91ll3vb0t6WZ2 > >										12
1327 //	        < 13 ; 24M ; JAN 2021 ; opt. ; - ; 0 ; 1,1619069767695 ; -1 ; -0,00025 ; 0,00025 ; -7,8 ; -7,6 ; -3,6 ; -4,9 ; 8,6 ; -1,4 ; 0,48 ; NABCNYJA2135 ; FEFfc7CC0fCeF52DeFadAABc6B0b9fc19dd17A0172cddA7B5fbaFb1Dc5E543eE ; < g6j72OP1NCJ7hSL1JWIhZKsGzgA3Z74E1q35aWic66K2GJQ7DvqPRLK2puS6K5N7 > >										13
1328 //	        < 14 ; 26M ; MAR 2021 ; opt. ; - ; 0 ; 1,16530819671831 ; -1 ; -0,00025 ; 0,00025 ; 6,8 ; -5,1 ; -2,8 ; 5,1 ; -2,5 ; 9,5 ; -0,6 ; NABCNYMA2159 ; 9dA7b7Ed9B54c6ecD3d8eDDEaFE7B352FDcedEbBbeF7F3dcD5bCEDF9bf1fCfc3 ; < DA33Sf075W65tqpGv6o3aier6qe9Ff33Ai5phyJ514sXml6EAdz1Q526Xq7133Gd > >										14
1329 //	        < 15 ; 28M ; MAY 2021 ; opt. ; - ; 0 ; 1,16903832023362 ; -1 ; -0,00025 ; 0,00025 ; 6,5 ; -4 ; -3,6 ; 8 ; 4,1 ; -3,8 ; -0,69 ; NABCNYMA2193 ; E5CA2EdCEbfCbDaC21ABBF6eB4bD5ADb8C4aFEF00bF7eCd0dC23Ffe9B3BaFDdf ; < o2wb9enLSJYxIiLu1N7Y8r75jFbd1ND028A0Q39lVZ387uVQVtFgaDfj6C4SM47p > >										15
1330 //	        < 16 ; 30M ; JUL 2021 ; opt. ; - ; 0 ; 1,17293790643596 ; -1 ; -0,00025 ; 0,00025 ; -1,4 ; -3,8 ; -5,3 ; -7,7 ; -3,7 ; -3,6 ; 0,73 ; NABCNYJU2119 ; 8DA5DAC9fFeB4A29dbABe0C5EfdcDAF9F0ecFaB55DA212DbFf9BadBAde6efbb7 ; < 1j3H5Mv1T9y9yZatR41AlPWzvg5M1rk2a4ZhsmZR5r297r7lze7IH0HEYPx7xp7A > >										16
1331 //	        < 17 ; 32M ; SEP 2021 ; opt. ; - ; 0 ; 1,17715756273991 ; -1 ; -0,00025 ; 0,00025 ; -5,7 ; 6,2 ; -5,9 ; -6,2 ; -8,9 ; 5,1 ; -0,78 ; NABCNYSE2194 ; 8aCFBF63ecFEDF9FA8B4F8d2A223FEbD41bAbdF6d55b940c6e7aDEaFEa447edC ; < l0A5OtztzB3FXEAWg3US0M7LOVV2DwffPWOwGMuuGwJYWXQHgXdaz5zC4SGz00ah > >										17
1332 //	        < 18 ; 35M ; DEC 2021 ; opt. ; - ; 0 ; 1,18146754007652 ; -1 ; -0,00025 ; 0,00025 ; -3,7 ; -9,9 ; -9,4 ; -2,7 ; 6,1 ; -3,8 ; 0,85 ; NABCNYDE2126 ; 96BF911B9FbbFE2BABCF3de329dfA1Ee6a7A9d9aE03bb158ddD77B6fE13d1eD1 ; < 7o1Z7fyB8zVpisPimcs6761x7nN3s6mMA9Hv8Kg8Um601hot1Wl0o3uk3PCsBztq > >										18
1333 //	        < 19 ; 36M ; JAN 2021 ; opt. ; - ; 0 ; 1,18614168395367 ; -1 ; -0,00025 ; 0,00025 ; -2,2 ; -8,9 ; -1,2 ; -2,2 ; -4,6 ; 6,4 ; -0,71 ; NABCNYJA2171 ; DFbedE0AE0013C7AaaC5A6eb59f9ceeEadEfeEb9dEf9c8Ca5fBc4da7AeA6C19D ; < uTy8gn6WgMdiVF13l3At3Puj8g2za7fha3462ypB6PkKYzFI254X1j7fuAgkyll6 > >										19
1334 //	        < 20 ; 38M ; MAR 2021 ; opt. ; - ; 0 ; 1,19119718340949 ; -1 ; -0,00025 ; 0,00025 ; 5,9 ; -8,2 ; 9,1 ; 3,4 ; 0,5 ; -2,1 ; -0,66 ; NABCNYMA2142 ; Ade71ADeE10C9caaC3eBB7fD450AdEaAbf0eCEEEC67e48bB7e9B40b8C5e55424 ; < 4lLyJsKpElf6AU13nG9i98zD0ZzkxhNXFT60Bi0nS53fE7Frt9TJw1UTmIGg5YTX > >										20
1335 //	        < 21 ; 40M ; MAY 2021 ; opt. ; - ; 0 ; 1,19645643893813 ; -1 ; -0,00025 ; 0,00025 ; 0,2 ; 8,3 ; -8,8 ; 3,9 ; 2,8 ; -4,9 ; -0,49 ; NABCNYMA2175 ; 7F2CABaa9CDD9e4BBBacFF2A9Fec2beCf919b5ba4DEcC9DeD7af4979DDC1Aa9d ; < o465vaEGkP4jxV046jPR698E6QfUL6wNqSMTz559uP90091V25ZAUKqE44gNgqFH > >										21
1336 //	        < 22 ; 42M ; JUL 2021 ; opt. ; - ; 0 ; 1,20189924727131 ; -1 ; -0,00025 ; 0,00025 ; -7,5 ; 4,6 ; -2,4 ; -9,6 ; 9,3 ; 4,5 ; -0,38 ; NABCNYJU2159 ; 8dAfc3bDc35e1fED2c8CCD4aafbFEcefdedBddFDbB29BBabbd0aB1B9EDa1BaAc ; < GU32kzM05GZL59VvRv825Z2dhzl0goXPMZ4N84vz7k36l1VKTLAO582o0Ok71v98 > >										22
1337 //	        < 23 ; 44M ; SEP 2021 ; opt. ; - ; 0 ; 1,20770100332001 ; -1 ; -0,00025 ; 0,00025 ; 4 ; 3,5 ; 8 ; -0,6 ; 4,7 ; -1 ; -0,66 ; NABCNYSE2122 ; 3dfccB7abEba4dcBb8dEcCaaccfdB1e0CadA3Eef4D33cfc3Fd4cAEFB8dacEdD0 ; < 47kI1e3v4r773628TG4Y38VfKc20k9P3YL9DA7R9UrQ08P7hOWyeC481A3tD6k7Z > >										23
1338 //	        < 24 ; 47M ; DEC 2021 ; opt. ; - ; 0 ; 1,21380381841504 ; -1 ; -0,00025 ; 0,00025 ; -0,3 ; 0,1 ; -3,7 ; 8,1 ; 0,3 ; -3,2 ; 0,94 ; NABCNYDE2171 ; AD5e5a3f0A9fBcb9aFcAd2Ef765d3FFffb4AFedBaBbAD9BBA9Fb4AAEE0B95F12 ; < M3w1D4447l4x7Z0hi8rp816U6KMu8oMI99T8CxOnEvxy92CYW2LgNiDWS4NeLdN7 > >										24
1339 											
1340 //	  < CALLS ; 3M ; Strike ; Symbol ; Last ; T(-1) ; Change ; Volume ; BAS_1 ; BAS_2 ; o.i. @ eth_hex ; @ btc_882 >										
1341 											
1342 //	#DIV/0 !										1
1343 //	#DIV/0 !										2
1344 //	#DIV/0 !										3
1345 //	#DIV/0 !										4
1346 //	#DIV/0 !										5
1347 //	#DIV/0 !										6
1348 //	#DIV/0 !										7
1349 //	#DIV/0 !										8
1350 //	#DIV/0 !										9
1351 //	#DIV/0 !										10
1352 //	#DIV/0 !										11
1353 //	#DIV/0 !										12
1354 //	#DIV/0 !										13
1355 //	#DIV/0 !										14
1356 //	#DIV/0 !										15
1357 //	#DIV/0 !										16
1358 //	#DIV/0 !										17
1359 //	#DIV/0 !										18
1360 //	#DIV/0 !										19
1361 //	#DIV/0 !										20
1362 //	#DIV/0 !										21
1363 //											
1364 //	  < PUTS ; 3M ; Strike ; Symbol ; Last ; T(-1) ; Change ; Volume ; BAS_1 ; BAS_2 ; o.i. @ eth_hex ; @ btc_882 >										
1365 //											
1366 //	#DIV/0 !										1
1367 //	#DIV/0 !										2
1368 //	#DIV/0 !										3
1369 //	#DIV/0 !										4
1370 //	#DIV/0 !										5
1371 //	#DIV/0 !										6
1372 //	#DIV/0 !										7
1373 //	#DIV/0 !										8
1374 //	#DIV/0 !										9
1375 //	#DIV/0 !										10
1376 //	#DIV/0 !										11
1377 //	#DIV/0 !										12
1378 //	#DIV/0 !										13
1379 //	#DIV/0 !										14
1380 //	#DIV/0 !										15
1381 //	#DIV/0 !										16
1382 //	#DIV/0 !										17
1383 //	#DIV/0 !										18
1384 //	#DIV/0 !										19
1385 //	#DIV/0 !										20
1386 //	#DIV/0 !										21
1387 											
1388 											
1389 											
1390 											
1391 											
1392 //	NABCNY										
1393 											
1394 //	  < # ; REF ; Month ; Optionchain ; Chart ; Last ; T(-1) ; Change ; BAS_1 ; BAS_2 ; Prior. Settle ; Open ; High ; Low ; Volume ; Hi / Lo ; Updated (s) ; Code ; @ eth_hex ; @ btc_882 >										
1395 											
1396 //	        < 0 ; T0 ; - ; - ; - ; 0 ; 1,14 ; -1 ; - ; - ; - ; - ; - ; - ; - ; - ; - ; - ; 161bF94D215ACAD73A0058eF56DEdc8a0EBE8aD3aC9b5D8C0EfCBceaf5eddde9 ; < p0lVtq04AW915sCuurd9IMo7ewAd02z5XuO8AZ899704v6BmU47xYIJZ31BIpeD1 > >										0
1397 //	        < 1 ; 0M ; JAN 2019 ; opt. ; - ; 0 ; 1,14013006829845 ; -1 ; -0,00025 ; 0,00025 ; -4,7 ; -8 ; 1,6 ; -6,4 ; -2,2 ; 5 ; -0,33 ; NABCNY63JA19 ; D5CcdeC0dBafEb4EaA8bF25E5eBB81eCAAB6eDfeecffAA9B9DEa21ddaBeBdfd0 ; < sPy4Ie2907w1OC892rVqS2b46rCkA82BauCob0qY3551nHXgfysy7SiI6qr6HPG2 > >										1
1398 //	        < 2 ; 2M ; MAR 2019 ; opt. ; - ; 0 ; 1,14050657721427 ; -1 ; -0,00025 ; 0,00025 ; -3,7 ; -9,8 ; 6 ; 9 ; 2,3 ; -6,5 ; -0,94 ; NABCNYMA1919 ; 3FE89Da5C79AcB527d3005b4EEBCEA7DE00E876D51dc6Ff4BDF2AEfD9FEFf9e5 ; < 5T6Dh67YAH7KW85Mz6xwR22dzec3AcZ4v665J8r90P2pzy5g8wdqnXL44f973f6u > >										2
1399 //	        < 3 ; 4M ; MAY 2019 ; opt. ; - ; 0 ; 1,1412403961573 ; -1 ; -0,00025 ; 0,00025 ; 6,1 ; -8,9 ; -1 ; 2,4 ; -0,8 ; -3,6 ; -0,81 ; NABCNYMA1913 ; aaaDcBCEf8d3BfCb78116D7D631aaE82DDABCCE4B9fC3d14deE0CBfafeB9d5d8 ; < lTs2X2R2l2Bnqy0mSR8Ozke60QMh85g58Syj5F8MNUT4AaHBhkoMNE1Zlozev5oI > >										3
1400 //	        < 4 ; 6M ; JUL 2019 ; opt. ; - ; 0 ; 1,14215525993933 ; -1 ; -0,00025 ; 0,00025 ; -9,4 ; -4,6 ; -3,9 ; 8,4 ; 3,9 ; 1,2 ; 0,65 ; NABCNYJU1976 ; ccCA7CEDb3E1E1E5AC4FF643b8DAf5912CaBBA70454aCEEF499Ec24DeDB6c236 ; < 432VWTUx6hi6NcQDdr9Tv41312wj0kOb192AKpje19XkypR9iH0o2oS1NzT48QCy > >										4
1401 //	        < 5 ; 8M ; SEP 2019 ; opt. ; - ; 0 ; 1,14344236397449 ; -1 ; -0,00025 ; 0,00025 ; 8,6 ; -9,9 ; 6,3 ; 1,1 ; 9,3 ; -8,5 ; -0,99 ; NABCNYSE1988 ; BaBCECC0DFaEA9ACFbE8142cFb4e0e9ce7DB5Ce1c9cF02A83eC2a8AEFfDf7f0a ; < tXm4UQlCP275o5JDzbzw7YINcn916if9ds0K29fDVYbq4Uso0SX3OhV2luF0QH5Y > >										5
1402 //	        < 6 ; 11M ; DEC 2019 ; opt. ; - ; 0 ; 1,14496911077331 ; -1 ; -0,00025 ; 0,00025 ; -6,9 ; 7,8 ; -3,2 ; -4,8 ; -3,5 ; -1,1 ; -0,37 ; NABCNYDE1951 ; ADD9EbCecA8438CcDe94BbAB1E7DAF3cFd4daab21fc9efD3abEbcA63C7BcbDb2 ; < U63652m61QS6k92NGJv4Q32MC3k2Z61t30l8RjBiX9N7Fd1jh1Rsrw6Egkbtrl42 > >										6
1403 //	        < 7 ; 12M ; JAN 2020 ; opt. ; - ; 0 ; 1,14671813659638 ; -1 ; -0,00025 ; 0,00025 ; 5,7 ; -4,2 ; 2,5 ; -2,7 ; 6,4 ; 3,7 ; 0,87 ; NABCNYJA2019 ; 1C7fB2eEcAbB127Ef51258CeDedFB9Cbe6A4a27Ff2AB32c3FEa70DC0Ff1DfAED ; < 49e0T6etNJX15426TrFIG0CDHsu8Cy9PCDLx8gv197X0M9LdmJC1xSPE78B8ao2H > >										7
1404 //	        < 8 ; 14M ; MAR 2020 ; opt. ; - ; 0 ; 1,1486789936402 ; -1 ; -0,00025 ; 0,00025 ; 2,3 ; 3 ; 8,2 ; -3,4 ; 9,2 ; -9,5 ; 0,66 ; NABCNYMA2034 ; 6DceAaECEfca15DD8FfcEbCdAD98b6fBCB0fa4Fc4dBEe6B34eBAEF2dEf1eEfDe ; < 0DUz3452QlPjWBd1G19zRAtO92C917AFOABHb5422IlwCe98W13dc9xnIt60TWeb > >										8
1405 //	        < 9 ; 16M ; MAY 2020 ; opt. ; - ; 0 ; 1,15075513290672 ; -1 ; -0,00025 ; 0,00025 ; -7 ; 6,2 ; 9,4 ; -6,4 ; -3,5 ; 0,4 ; -0,08 ; NABCNYMA2082 ; 7F0769eeCCaFae5EfA9c6a6Ef0cA5C8de1BeEE7AdCcFcebE1A247f6adad07CBa ; < PE4cFA9OIt8UU9pY0lN0Fr3RR6mJwzPG6mVe0ihL2008owKCoeWe7d22JLH1Jhj1 > >										9
1406 //	        < 10 ; 18M ; JUL 2020 ; opt. ; - ; 0 ; 1,15323719633868 ; -1 ; -0,00025 ; 0,00025 ; -3,2 ; 0,4 ; -1,5 ; -1,1 ; 3,2 ; -5,3 ; 0,98 ; NABCNYJU2013 ; ACCDCc2deeCC4bC7DDCdB8FbbD961E44bF3bBcE5ddAC7eEeE19AAdCf0fA413EE ; < rD22agS9q4IU2FbPL6YDE6L70AoKTOybcW3bcTA4MM25Em34cfnv9RAR0BR422XB > >										10
1407 //	        < 11 ; 20M ; SEP 2020 ; opt. ; - ; 0 ; 1,15592473278381 ; -1 ; -0,00025 ; 0,00025 ; 4,6 ; -9,9 ; 4,7 ; -9,7 ; -0,5 ; -9,5 ; 0,51 ; NABCNYSE2084 ; Aa37CbE4aCAc30B2614FeDcC3Fc75423eF99b8eDC0A53DcdcC6AddfABE8A8725 ; < 683lRCz8K4tn2P0G1adTNZ03e1T15V4W97UJtS87s2CY122M2e40K2w1pMUPnt6B > >										11
1408 //	        < 12 ; 23M ; DEC 2020 ; opt. ; - ; 0 ; 1,15882725978783 ; -1 ; -0,00025 ; 0,00025 ; 8,3 ; 7,8 ; -2,4 ; 9,9 ; 8,8 ; 9,1 ; -0,16 ; NABCNYDE2024 ; CfCFd78c988Cb402f6aFc0BdfeAACDabFAc8CbcadAbac6aDdAB32cABFC12eBFE ; < 3wV37G6b0yfQXP7hoOEEE94u14i7Q1t4qnRMpXqar0ACTup0F9m91ll3vb0t6WZ2 > >										12
1409 //	        < 13 ; 24M ; JAN 2021 ; opt. ; - ; 0 ; 1,1619069767695 ; -1 ; -0,00025 ; 0,00025 ; -7,8 ; -7,6 ; -3,6 ; -4,9 ; 8,6 ; -1,4 ; 0,48 ; NABCNYJA2135 ; FEFfc7CC0fCeF52DeFadAABc6B0b9fc19dd17A0172cddA7B5fbaFb1Dc5E543eE ; < g6j72OP1NCJ7hSL1JWIhZKsGzgA3Z74E1q35aWic66K2GJQ7DvqPRLK2puS6K5N7 > >										13
1410 //	        < 14 ; 26M ; MAR 2021 ; opt. ; - ; 0 ; 1,16530819671831 ; -1 ; -0,00025 ; 0,00025 ; 6,8 ; -5,1 ; -2,8 ; 5,1 ; -2,5 ; 9,5 ; -0,6 ; NABCNYMA2159 ; 9dA7b7Ed9B54c6ecD3d8eDDEaFE7B352FDcedEbBbeF7F3dcD5bCEDF9bf1fCfc3 ; < DA33Sf075W65tqpGv6o3aier6qe9Ff33Ai5phyJ514sXml6EAdz1Q526Xq7133Gd > >										14
1411 //	        < 15 ; 28M ; MAY 2021 ; opt. ; - ; 0 ; 1,16903832023362 ; -1 ; -0,00025 ; 0,00025 ; 6,5 ; -4 ; -3,6 ; 8 ; 4,1 ; -3,8 ; -0,69 ; NABCNYMA2193 ; E5CA2EdCEbfCbDaC21ABBF6eB4bD5ADb8C4aFEF00bF7eCd0dC23Ffe9B3BaFDdf ; < o2wb9enLSJYxIiLu1N7Y8r75jFbd1ND028A0Q39lVZ387uVQVtFgaDfj6C4SM47p > >										15
1412 //	        < 16 ; 30M ; JUL 2021 ; opt. ; - ; 0 ; 1,17293790643596 ; -1 ; -0,00025 ; 0,00025 ; -1,4 ; -3,8 ; -5,3 ; -7,7 ; -3,7 ; -3,6 ; 0,73 ; NABCNYJU2119 ; 8DA5DAC9fFeB4A29dbABe0C5EfdcDAF9F0ecFaB55DA212DbFf9BadBAde6efbb7 ; < 1j3H5Mv1T9y9yZatR41AlPWzvg5M1rk2a4ZhsmZR5r297r7lze7IH0HEYPx7xp7A > >										16
1413 //	        < 17 ; 32M ; SEP 2021 ; opt. ; - ; 0 ; 1,17715756273991 ; -1 ; -0,00025 ; 0,00025 ; -5,7 ; 6,2 ; -5,9 ; -6,2 ; -8,9 ; 5,1 ; -0,78 ; NABCNYSE2194 ; 8aCFBF63ecFEDF9FA8B4F8d2A223FEbD41bAbdF6d55b940c6e7aDEaFEa447edC ; < l0A5OtztzB3FXEAWg3US0M7LOVV2DwffPWOwGMuuGwJYWXQHgXdaz5zC4SGz00ah > >										17
1414 //	        < 18 ; 35M ; DEC 2021 ; opt. ; - ; 0 ; 1,18146754007652 ; -1 ; -0,00025 ; 0,00025 ; -3,7 ; -9,9 ; -9,4 ; -2,7 ; 6,1 ; -3,8 ; 0,85 ; NABCNYDE2126 ; 96BF911B9FbbFE2BABCF3de329dfA1Ee6a7A9d9aE03bb158ddD77B6fE13d1eD1 ; < 7o1Z7fyB8zVpisPimcs6761x7nN3s6mMA9Hv8Kg8Um601hot1Wl0o3uk3PCsBztq > >										18
1415 //	        < 19 ; 36M ; JAN 2021 ; opt. ; - ; 0 ; 1,18614168395367 ; -1 ; -0,00025 ; 0,00025 ; -2,2 ; -8,9 ; -1,2 ; -2,2 ; -4,6 ; 6,4 ; -0,71 ; NABCNYJA2171 ; DFbedE0AE0013C7AaaC5A6eb59f9ceeEadEfeEb9dEf9c8Ca5fBc4da7AeA6C19D ; < uTy8gn6WgMdiVF13l3At3Puj8g2za7fha3462ypB6PkKYzFI254X1j7fuAgkyll6 > >										19
1416 //	        < 20 ; 38M ; MAR 2021 ; opt. ; - ; 0 ; 1,19119718340949 ; -1 ; -0,00025 ; 0,00025 ; 5,9 ; -8,2 ; 9,1 ; 3,4 ; 0,5 ; -2,1 ; -0,66 ; NABCNYMA2142 ; Ade71ADeE10C9caaC3eBB7fD450AdEaAbf0eCEEEC67e48bB7e9B40b8C5e55424 ; < 4lLyJsKpElf6AU13nG9i98zD0ZzkxhNXFT60Bi0nS53fE7Frt9TJw1UTmIGg5YTX > >										20
1417 //	        < 21 ; 40M ; MAY 2021 ; opt. ; - ; 0 ; 1,19645643893813 ; -1 ; -0,00025 ; 0,00025 ; 0,2 ; 8,3 ; -8,8 ; 3,9 ; 2,8 ; -4,9 ; -0,49 ; NABCNYMA2175 ; 7F2CABaa9CDD9e4BBBacFF2A9Fec2beCf919b5ba4DEcC9DeD7af4979DDC1Aa9d ; < o465vaEGkP4jxV046jPR698E6QfUL6wNqSMTz559uP90091V25ZAUKqE44gNgqFH > >										21
1418 //	        < 22 ; 42M ; JUL 2021 ; opt. ; - ; 0 ; 1,20189924727131 ; -1 ; -0,00025 ; 0,00025 ; -7,5 ; 4,6 ; -2,4 ; -9,6 ; 9,3 ; 4,5 ; -0,38 ; NABCNYJU2159 ; 8dAfc3bDc35e1fED2c8CCD4aafbFEcefdedBddFDbB29BBabbd0aB1B9EDa1BaAc ; < GU32kzM05GZL59VvRv825Z2dhzl0goXPMZ4N84vz7k36l1VKTLAO582o0Ok71v98 > >										22
1419 //	        < 23 ; 44M ; SEP 2021 ; opt. ; - ; 0 ; 1,20770100332001 ; -1 ; -0,00025 ; 0,00025 ; 4 ; 3,5 ; 8 ; -0,6 ; 4,7 ; -1 ; -0,66 ; NABCNYSE2122 ; 3dfccB7abEba4dcBb8dEcCaaccfdB1e0CadA3Eef4D33cfc3Fd4cAEFB8dacEdD0 ; < 47kI1e3v4r773628TG4Y38VfKc20k9P3YL9DA7R9UrQ08P7hOWyeC481A3tD6k7Z > >										23
1420 //	        < 24 ; 47M ; DEC 2021 ; opt. ; - ; 0 ; 1,21380381841504 ; -1 ; -0,00025 ; 0,00025 ; -0,3 ; 0,1 ; -3,7 ; 8,1 ; 0,3 ; -3,2 ; 0,94 ; NABCNYDE2171 ; AD5e5a3f0A9fBcb9aFcAd2Ef765d3FFffb4AFedBaBbAD9BBA9Fb4AAEE0B95F12 ; < M3w1D4447l4x7Z0hi8rp816U6KMu8oMI99T8CxOnEvxy92CYW2LgNiDWS4NeLdN7 > >										24
1421 											
1422 //	  < CALLS ; 6M ; Strike ; Symbol ; Last ; T(-1) ; Change ; Volume ; BAS_1 ; BAS_2 ; o.i. @ eth_hex ; @ btc_882 >										
1423 											
1424 //	#DIV/0 !										1
1425 //	#DIV/0 !										2
1426 //	#DIV/0 !										3
1427 //	#DIV/0 !										4
1428 //	#DIV/0 !										5
1429 //	#DIV/0 !										6
1430 //	#DIV/0 !										7
1431 //	#DIV/0 !										8
1432 //	#DIV/0 !										9
1433 //	#DIV/0 !										10
1434 //	#DIV/0 !										11
1435 //	#DIV/0 !										12
1436 //	#DIV/0 !										13
1437 //	#DIV/0 !										14
1438 //	#DIV/0 !										15
1439 //	#DIV/0 !										16
1440 //	#DIV/0 !										17
1441 //	#DIV/0 !										18
1442 //	#DIV/0 !										19
1443 //	#DIV/0 !										20
1444 //	#DIV/0 !										21
1445 //											
1446 //	  < PUTS ; 6M ; Strike ; Symbol ; Last ; T(-1) ; Change ; Volume ; BAS_1 ; BAS_2 ; o.i. @ eth_hex ; @ btc_882 >										
1447 //											
1448 //	#DIV/0 !										1
1449 //	#DIV/0 !										2
1450 //	#DIV/0 !										3
1451 //	#DIV/0 !										4
1452 //	#DIV/0 !										5
1453 //	#DIV/0 !										6
1454 //	#DIV/0 !										7
1455 //	#DIV/0 !										8
1456 //	#DIV/0 !										9
1457 //	#DIV/0 !										10
1458 //	#DIV/0 !										11
1459 //	#DIV/0 !										12
1460 //	#DIV/0 !										13
1461 //	#DIV/0 !										14
1462 //	#DIV/0 !										15
1463 //	#DIV/0 !										16
1464 //	#DIV/0 !										17
1465 //	#DIV/0 !										18
1466 //	#DIV/0 !										19
1467 //	#DIV/0 !										20
1468 //	#DIV/0 !										21
1469 											
1470 											
1471 											
1472 											
1473 											
1474 //	NABCNY										
1475 											
1476 //	  < # ; REF ; Month ; Optionchain ; Chart ; Last ; T(-1) ; Change ; BAS_1 ; BAS_2 ; Prior. Settle ; Open ; High ; Low ; Volume ; Hi / Lo ; Updated (s) ; Code ; @ eth_hex ; @ btc_882 >										
1477 											
1478 //	        < 0 ; T0 ; - ; - ; - ; 0 ; 1,14 ; -1 ; - ; - ; - ; - ; - ; - ; - ; - ; - ; - ; 161bF94D215ACAD73A0058eF56DEdc8a0EBE8aD3aC9b5D8C0EfCBceaf5eddde9 ; < p0lVtq04AW915sCuurd9IMo7ewAd02z5XuO8AZ899704v6BmU47xYIJZ31BIpeD1 > >										0
1479 //	        < 1 ; 0M ; JAN 2019 ; opt. ; - ; 0 ; 1,14013006829845 ; -1 ; -0,00025 ; 0,00025 ; -4,7 ; -8 ; 1,6 ; -6,4 ; -2,2 ; 5 ; -0,33 ; NABCNY63JA19 ; D5CcdeC0dBafEb4EaA8bF25E5eBB81eCAAB6eDfeecffAA9B9DEa21ddaBeBdfd0 ; < sPy4Ie2907w1OC892rVqS2b46rCkA82BauCob0qY3551nHXgfysy7SiI6qr6HPG2 > >										1
1480 //	        < 2 ; 2M ; MAR 2019 ; opt. ; - ; 0 ; 1,14050657721427 ; -1 ; -0,00025 ; 0,00025 ; -3,7 ; -9,8 ; 6 ; 9 ; 2,3 ; -6,5 ; -0,94 ; NABCNYMA1919 ; 3FE89Da5C79AcB527d3005b4EEBCEA7DE00E876D51dc6Ff4BDF2AEfD9FEFf9e5 ; < 5T6Dh67YAH7KW85Mz6xwR22dzec3AcZ4v665J8r90P2pzy5g8wdqnXL44f973f6u > >										2
1481 //	        < 3 ; 4M ; MAY 2019 ; opt. ; - ; 0 ; 1,1412403961573 ; -1 ; -0,00025 ; 0,00025 ; 6,1 ; -8,9 ; -1 ; 2,4 ; -0,8 ; -3,6 ; -0,81 ; NABCNYMA1913 ; aaaDcBCEf8d3BfCb78116D7D631aaE82DDABCCE4B9fC3d14deE0CBfafeB9d5d8 ; < lTs2X2R2l2Bnqy0mSR8Ozke60QMh85g58Syj5F8MNUT4AaHBhkoMNE1Zlozev5oI > >										3
1482 //	        < 4 ; 6M ; JUL 2019 ; opt. ; - ; 0 ; 1,14215525993933 ; -1 ; -0,00025 ; 0,00025 ; -9,4 ; -4,6 ; -3,9 ; 8,4 ; 3,9 ; 1,2 ; 0,65 ; NABCNYJU1976 ; ccCA7CEDb3E1E1E5AC4FF643b8DAf5912CaBBA70454aCEEF499Ec24DeDB6c236 ; < 432VWTUx6hi6NcQDdr9Tv41312wj0kOb192AKpje19XkypR9iH0o2oS1NzT48QCy > >										4
1483 //	        < 5 ; 8M ; SEP 2019 ; opt. ; - ; 0 ; 1,14344236397449 ; -1 ; -0,00025 ; 0,00025 ; 8,6 ; -9,9 ; 6,3 ; 1,1 ; 9,3 ; -8,5 ; -0,99 ; NABCNYSE1988 ; BaBCECC0DFaEA9ACFbE8142cFb4e0e9ce7DB5Ce1c9cF02A83eC2a8AEFfDf7f0a ; < tXm4UQlCP275o5JDzbzw7YINcn916if9ds0K29fDVYbq4Uso0SX3OhV2luF0QH5Y > >										5
1484 //	        < 6 ; 11M ; DEC 2019 ; opt. ; - ; 0 ; 1,14496911077331 ; -1 ; -0,00025 ; 0,00025 ; -6,9 ; 7,8 ; -3,2 ; -4,8 ; -3,5 ; -1,1 ; -0,37 ; NABCNYDE1951 ; ADD9EbCecA8438CcDe94BbAB1E7DAF3cFd4daab21fc9efD3abEbcA63C7BcbDb2 ; < U63652m61QS6k92NGJv4Q32MC3k2Z61t30l8RjBiX9N7Fd1jh1Rsrw6Egkbtrl42 > >										6
1485 //	        < 7 ; 12M ; JAN 2020 ; opt. ; - ; 0 ; 1,14671813659638 ; -1 ; -0,00025 ; 0,00025 ; 5,7 ; -4,2 ; 2,5 ; -2,7 ; 6,4 ; 3,7 ; 0,87 ; NABCNYJA2019 ; 1C7fB2eEcAbB127Ef51258CeDedFB9Cbe6A4a27Ff2AB32c3FEa70DC0Ff1DfAED ; < 49e0T6etNJX15426TrFIG0CDHsu8Cy9PCDLx8gv197X0M9LdmJC1xSPE78B8ao2H > >										7
1486 //	        < 8 ; 14M ; MAR 2020 ; opt. ; - ; 0 ; 1,1486789936402 ; -1 ; -0,00025 ; 0,00025 ; 2,3 ; 3 ; 8,2 ; -3,4 ; 9,2 ; -9,5 ; 0,66 ; NABCNYMA2034 ; 6DceAaECEfca15DD8FfcEbCdAD98b6fBCB0fa4Fc4dBEe6B34eBAEF2dEf1eEfDe ; < 0DUz3452QlPjWBd1G19zRAtO92C917AFOABHb5422IlwCe98W13dc9xnIt60TWeb > >										8
1487 //	        < 9 ; 16M ; MAY 2020 ; opt. ; - ; 0 ; 1,15075513290672 ; -1 ; -0,00025 ; 0,00025 ; -7 ; 6,2 ; 9,4 ; -6,4 ; -3,5 ; 0,4 ; -0,08 ; NABCNYMA2082 ; 7F0769eeCCaFae5EfA9c6a6Ef0cA5C8de1BeEE7AdCcFcebE1A247f6adad07CBa ; < PE4cFA9OIt8UU9pY0lN0Fr3RR6mJwzPG6mVe0ihL2008owKCoeWe7d22JLH1Jhj1 > >										9
1488 //	        < 10 ; 18M ; JUL 2020 ; opt. ; - ; 0 ; 1,15323719633868 ; -1 ; -0,00025 ; 0,00025 ; -3,2 ; 0,4 ; -1,5 ; -1,1 ; 3,2 ; -5,3 ; 0,98 ; NABCNYJU2013 ; ACCDCc2deeCC4bC7DDCdB8FbbD961E44bF3bBcE5ddAC7eEeE19AAdCf0fA413EE ; < rD22agS9q4IU2FbPL6YDE6L70AoKTOybcW3bcTA4MM25Em34cfnv9RAR0BR422XB > >										10
1489 //	        < 11 ; 20M ; SEP 2020 ; opt. ; - ; 0 ; 1,15592473278381 ; -1 ; -0,00025 ; 0,00025 ; 4,6 ; -9,9 ; 4,7 ; -9,7 ; -0,5 ; -9,5 ; 0,51 ; NABCNYSE2084 ; Aa37CbE4aCAc30B2614FeDcC3Fc75423eF99b8eDC0A53DcdcC6AddfABE8A8725 ; < 683lRCz8K4tn2P0G1adTNZ03e1T15V4W97UJtS87s2CY122M2e40K2w1pMUPnt6B > >										11
1490 //	        < 12 ; 23M ; DEC 2020 ; opt. ; - ; 0 ; 1,15882725978783 ; -1 ; -0,00025 ; 0,00025 ; 8,3 ; 7,8 ; -2,4 ; 9,9 ; 8,8 ; 9,1 ; -0,16 ; NABCNYDE2024 ; CfCFd78c988Cb402f6aFc0BdfeAACDabFAc8CbcadAbac6aDdAB32cABFC12eBFE ; < 3wV37G6b0yfQXP7hoOEEE94u14i7Q1t4qnRMpXqar0ACTup0F9m91ll3vb0t6WZ2 > >										12
1491 //	        < 13 ; 24M ; JAN 2021 ; opt. ; - ; 0 ; 1,1619069767695 ; -1 ; -0,00025 ; 0,00025 ; -7,8 ; -7,6 ; -3,6 ; -4,9 ; 8,6 ; -1,4 ; 0,48 ; NABCNYJA2135 ; FEFfc7CC0fCeF52DeFadAABc6B0b9fc19dd17A0172cddA7B5fbaFb1Dc5E543eE ; < g6j72OP1NCJ7hSL1JWIhZKsGzgA3Z74E1q35aWic66K2GJQ7DvqPRLK2puS6K5N7 > >										13
1492 //	        < 14 ; 26M ; MAR 2021 ; opt. ; - ; 0 ; 1,16530819671831 ; -1 ; -0,00025 ; 0,00025 ; 6,8 ; -5,1 ; -2,8 ; 5,1 ; -2,5 ; 9,5 ; -0,6 ; NABCNYMA2159 ; 9dA7b7Ed9B54c6ecD3d8eDDEaFE7B352FDcedEbBbeF7F3dcD5bCEDF9bf1fCfc3 ; < DA33Sf075W65tqpGv6o3aier6qe9Ff33Ai5phyJ514sXml6EAdz1Q526Xq7133Gd > >										14
1493 //	        < 15 ; 28M ; MAY 2021 ; opt. ; - ; 0 ; 1,16903832023362 ; -1 ; -0,00025 ; 0,00025 ; 6,5 ; -4 ; -3,6 ; 8 ; 4,1 ; -3,8 ; -0,69 ; NABCNYMA2193 ; E5CA2EdCEbfCbDaC21ABBF6eB4bD5ADb8C4aFEF00bF7eCd0dC23Ffe9B3BaFDdf ; < o2wb9enLSJYxIiLu1N7Y8r75jFbd1ND028A0Q39lVZ387uVQVtFgaDfj6C4SM47p > >										15
1494 //	        < 16 ; 30M ; JUL 2021 ; opt. ; - ; 0 ; 1,17293790643596 ; -1 ; -0,00025 ; 0,00025 ; -1,4 ; -3,8 ; -5,3 ; -7,7 ; -3,7 ; -3,6 ; 0,73 ; NABCNYJU2119 ; 8DA5DAC9fFeB4A29dbABe0C5EfdcDAF9F0ecFaB55DA212DbFf9BadBAde6efbb7 ; < 1j3H5Mv1T9y9yZatR41AlPWzvg5M1rk2a4ZhsmZR5r297r7lze7IH0HEYPx7xp7A > >										16
1495 //	        < 17 ; 32M ; SEP 2021 ; opt. ; - ; 0 ; 1,17715756273991 ; -1 ; -0,00025 ; 0,00025 ; -5,7 ; 6,2 ; -5,9 ; -6,2 ; -8,9 ; 5,1 ; -0,78 ; NABCNYSE2194 ; 8aCFBF63ecFEDF9FA8B4F8d2A223FEbD41bAbdF6d55b940c6e7aDEaFEa447edC ; < l0A5OtztzB3FXEAWg3US0M7LOVV2DwffPWOwGMuuGwJYWXQHgXdaz5zC4SGz00ah > >										17
1496 //	        < 18 ; 35M ; DEC 2021 ; opt. ; - ; 0 ; 1,18146754007652 ; -1 ; -0,00025 ; 0,00025 ; -3,7 ; -9,9 ; -9,4 ; -2,7 ; 6,1 ; -3,8 ; 0,85 ; NABCNYDE2126 ; 96BF911B9FbbFE2BABCF3de329dfA1Ee6a7A9d9aE03bb158ddD77B6fE13d1eD1 ; < 7o1Z7fyB8zVpisPimcs6761x7nN3s6mMA9Hv8Kg8Um601hot1Wl0o3uk3PCsBztq > >										18
1497 //	        < 19 ; 36M ; JAN 2021 ; opt. ; - ; 0 ; 1,18614168395367 ; -1 ; -0,00025 ; 0,00025 ; -2,2 ; -8,9 ; -1,2 ; -2,2 ; -4,6 ; 6,4 ; -0,71 ; NABCNYJA2171 ; DFbedE0AE0013C7AaaC5A6eb59f9ceeEadEfeEb9dEf9c8Ca5fBc4da7AeA6C19D ; < uTy8gn6WgMdiVF13l3At3Puj8g2za7fha3462ypB6PkKYzFI254X1j7fuAgkyll6 > >										19
1498 //	        < 20 ; 38M ; MAR 2021 ; opt. ; - ; 0 ; 1,19119718340949 ; -1 ; -0,00025 ; 0,00025 ; 5,9 ; -8,2 ; 9,1 ; 3,4 ; 0,5 ; -2,1 ; -0,66 ; NABCNYMA2142 ; Ade71ADeE10C9caaC3eBB7fD450AdEaAbf0eCEEEC67e48bB7e9B40b8C5e55424 ; < 4lLyJsKpElf6AU13nG9i98zD0ZzkxhNXFT60Bi0nS53fE7Frt9TJw1UTmIGg5YTX > >										20
1499 //	        < 21 ; 40M ; MAY 2021 ; opt. ; - ; 0 ; 1,19645643893813 ; -1 ; -0,00025 ; 0,00025 ; 0,2 ; 8,3 ; -8,8 ; 3,9 ; 2,8 ; -4,9 ; -0,49 ; NABCNYMA2175 ; 7F2CABaa9CDD9e4BBBacFF2A9Fec2beCf919b5ba4DEcC9DeD7af4979DDC1Aa9d ; < o465vaEGkP4jxV046jPR698E6QfUL6wNqSMTz559uP90091V25ZAUKqE44gNgqFH > >										21
1500 //	        < 22 ; 42M ; JUL 2021 ; opt. ; - ; 0 ; 1,20189924727131 ; -1 ; -0,00025 ; 0,00025 ; -7,5 ; 4,6 ; -2,4 ; -9,6 ; 9,3 ; 4,5 ; -0,38 ; NABCNYJU2159 ; 8dAfc3bDc35e1fED2c8CCD4aafbFEcefdedBddFDbB29BBabbd0aB1B9EDa1BaAc ; < GU32kzM05GZL59VvRv825Z2dhzl0goXPMZ4N84vz7k36l1VKTLAO582o0Ok71v98 > >										22
1501 //	        < 23 ; 44M ; SEP 2021 ; opt. ; - ; 0 ; 1,20770100332001 ; -1 ; -0,00025 ; 0,00025 ; 4 ; 3,5 ; 8 ; -0,6 ; 4,7 ; -1 ; -0,66 ; NABCNYSE2122 ; 3dfccB7abEba4dcBb8dEcCaaccfdB1e0CadA3Eef4D33cfc3Fd4cAEFB8dacEdD0 ; < 47kI1e3v4r773628TG4Y38VfKc20k9P3YL9DA7R9UrQ08P7hOWyeC481A3tD6k7Z > >										23
1502 //	        < 24 ; 47M ; DEC 2021 ; opt. ; - ; 0 ; 1,21380381841504 ; -1 ; -0,00025 ; 0,00025 ; -0,3 ; 0,1 ; -3,7 ; 8,1 ; 0,3 ; -3,2 ; 0,94 ; NABCNYDE2171 ; AD5e5a3f0A9fBcb9aFcAd2Ef765d3FFffb4AFedBaBbAD9BBA9Fb4AAEE0B95F12 ; < M3w1D4447l4x7Z0hi8rp816U6KMu8oMI99T8CxOnEvxy92CYW2LgNiDWS4NeLdN7 > >										24
1503 											
1504 //	  < CALLS ; 12M ; Strike ; Symbol ; Last ; T(-1) ; Change ; Volume ; BAS_1 ; BAS_2 ; o.i. @ eth_hex ; @ btc_882 >										
1505 											
1506 //	#DIV/0 !										1
1507 //	#DIV/0 !										2
1508 //	#DIV/0 !										3
1509 //	#DIV/0 !										4
1510 //	#DIV/0 !										5
1511 //	#DIV/0 !										6
1512 //	#DIV/0 !										7
1513 //	#DIV/0 !										8
1514 //	#DIV/0 !										9
1515 //	#DIV/0 !										10
1516 //	#DIV/0 !										11
1517 //	#DIV/0 !										12
1518 //	#DIV/0 !										13
1519 //	#DIV/0 !										14
1520 //	#DIV/0 !										15
1521 //	#DIV/0 !										16
1522 //	#DIV/0 !										17
1523 //	#DIV/0 !										18
1524 //	#DIV/0 !										19
1525 //	#DIV/0 !										20
1526 //	#DIV/0 !										21
1527 //											
1528 //	  < PUTS ; 12M ; Strike ; Symbol ; Last ; T(-1) ; Change ; Volume ; BAS_1 ; BAS_2 ; o.i. @ eth_hex ; @ btc_882 >										
1529 //											
1530 //	#DIV/0 !										1
1531 //	#DIV/0 !										2
1532 //	#DIV/0 !										3
1533 //	#DIV/0 !										4
1534 //	#DIV/0 !										5
1535 //	#DIV/0 !										6
1536 //	#DIV/0 !										7
1537 //	#DIV/0 !										8
1538 //	#DIV/0 !										9
1539 //	#DIV/0 !										10
1540 //	#DIV/0 !										11
1541 //	#DIV/0 !										12
1542 //	#DIV/0 !										13
1543 //	#DIV/0 !										14
1544 //	#DIV/0 !										15
1545 //	#DIV/0 !										16
1546 //	#DIV/0 !										17
1547 //	#DIV/0 !										18
1548 //	#DIV/0 !										19
1549 //	#DIV/0 !										20
1550 //	#DIV/0 !										21
1551 											
1552 											
1553 											
1554 											
1555 											
1556 //	NABCNY										
1557 											
1558 //	  < # ; REF ; Month ; Optionchain ; Chart ; Last ; T(-1) ; Change ; BAS_1 ; BAS_2 ; Prior. Settle ; Open ; High ; Low ; Volume ; Hi / Lo ; Updated (s) ; Code ; @ eth_hex ; @ btc_882 >										
1559 											
1560 //	        < 0 ; T0 ; - ; - ; - ; 0 ; 1,14 ; -1 ; - ; - ; - ; - ; - ; - ; - ; - ; - ; - ; 161bF94D215ACAD73A0058eF56DEdc8a0EBE8aD3aC9b5D8C0EfCBceaf5eddde9 ; < p0lVtq04AW915sCuurd9IMo7ewAd02z5XuO8AZ899704v6BmU47xYIJZ31BIpeD1 > >										0
1561 //	        < 1 ; 0M ; JAN 2019 ; opt. ; - ; 0 ; 1,14013006829845 ; -1 ; -0,00025 ; 0,00025 ; -4,7 ; -8 ; 1,6 ; -6,4 ; -2,2 ; 5 ; -0,33 ; NABCNY63JA19 ; D5CcdeC0dBafEb4EaA8bF25E5eBB81eCAAB6eDfeecffAA9B9DEa21ddaBeBdfd0 ; < sPy4Ie2907w1OC892rVqS2b46rCkA82BauCob0qY3551nHXgfysy7SiI6qr6HPG2 > >										1
1562 //	        < 2 ; 2M ; MAR 2019 ; opt. ; - ; 0 ; 1,14050657721427 ; -1 ; -0,00025 ; 0,00025 ; -3,7 ; -9,8 ; 6 ; 9 ; 2,3 ; -6,5 ; -0,94 ; NABCNYMA1919 ; 3FE89Da5C79AcB527d3005b4EEBCEA7DE00E876D51dc6Ff4BDF2AEfD9FEFf9e5 ; < 5T6Dh67YAH7KW85Mz6xwR22dzec3AcZ4v665J8r90P2pzy5g8wdqnXL44f973f6u > >										2
1563 //	        < 3 ; 4M ; MAY 2019 ; opt. ; - ; 0 ; 1,1412403961573 ; -1 ; -0,00025 ; 0,00025 ; 6,1 ; -8,9 ; -1 ; 2,4 ; -0,8 ; -3,6 ; -0,81 ; NABCNYMA1913 ; aaaDcBCEf8d3BfCb78116D7D631aaE82DDABCCE4B9fC3d14deE0CBfafeB9d5d8 ; < lTs2X2R2l2Bnqy0mSR8Ozke60QMh85g58Syj5F8MNUT4AaHBhkoMNE1Zlozev5oI > >										3
1564 //	        < 4 ; 6M ; JUL 2019 ; opt. ; - ; 0 ; 1,14215525993933 ; -1 ; -0,00025 ; 0,00025 ; -9,4 ; -4,6 ; -3,9 ; 8,4 ; 3,9 ; 1,2 ; 0,65 ; NABCNYJU1976 ; ccCA7CEDb3E1E1E5AC4FF643b8DAf5912CaBBA70454aCEEF499Ec24DeDB6c236 ; < 432VWTUx6hi6NcQDdr9Tv41312wj0kOb192AKpje19XkypR9iH0o2oS1NzT48QCy > >										4
1565 //	        < 5 ; 8M ; SEP 2019 ; opt. ; - ; 0 ; 1,14344236397449 ; -1 ; -0,00025 ; 0,00025 ; 8,6 ; -9,9 ; 6,3 ; 1,1 ; 9,3 ; -8,5 ; -0,99 ; NABCNYSE1988 ; BaBCECC0DFaEA9ACFbE8142cFb4e0e9ce7DB5Ce1c9cF02A83eC2a8AEFfDf7f0a ; < tXm4UQlCP275o5JDzbzw7YINcn916if9ds0K29fDVYbq4Uso0SX3OhV2luF0QH5Y > >										5
1566 //	        < 6 ; 11M ; DEC 2019 ; opt. ; - ; 0 ; 1,14496911077331 ; -1 ; -0,00025 ; 0,00025 ; -6,9 ; 7,8 ; -3,2 ; -4,8 ; -3,5 ; -1,1 ; -0,37 ; NABCNYDE1951 ; ADD9EbCecA8438CcDe94BbAB1E7DAF3cFd4daab21fc9efD3abEbcA63C7BcbDb2 ; < U63652m61QS6k92NGJv4Q32MC3k2Z61t30l8RjBiX9N7Fd1jh1Rsrw6Egkbtrl42 > >										6
1567 //	        < 7 ; 12M ; JAN 2020 ; opt. ; - ; 0 ; 1,14671813659638 ; -1 ; -0,00025 ; 0,00025 ; 5,7 ; -4,2 ; 2,5 ; -2,7 ; 6,4 ; 3,7 ; 0,87 ; NABCNYJA2019 ; 1C7fB2eEcAbB127Ef51258CeDedFB9Cbe6A4a27Ff2AB32c3FEa70DC0Ff1DfAED ; < 49e0T6etNJX15426TrFIG0CDHsu8Cy9PCDLx8gv197X0M9LdmJC1xSPE78B8ao2H > >										7
1568 //	        < 8 ; 14M ; MAR 2020 ; opt. ; - ; 0 ; 1,1486789936402 ; -1 ; -0,00025 ; 0,00025 ; 2,3 ; 3 ; 8,2 ; -3,4 ; 9,2 ; -9,5 ; 0,66 ; NABCNYMA2034 ; 6DceAaECEfca15DD8FfcEbCdAD98b6fBCB0fa4Fc4dBEe6B34eBAEF2dEf1eEfDe ; < 0DUz3452QlPjWBd1G19zRAtO92C917AFOABHb5422IlwCe98W13dc9xnIt60TWeb > >										8
1569 //	        < 9 ; 16M ; MAY 2020 ; opt. ; - ; 0 ; 1,15075513290672 ; -1 ; -0,00025 ; 0,00025 ; -7 ; 6,2 ; 9,4 ; -6,4 ; -3,5 ; 0,4 ; -0,08 ; NABCNYMA2082 ; 7F0769eeCCaFae5EfA9c6a6Ef0cA5C8de1BeEE7AdCcFcebE1A247f6adad07CBa ; < PE4cFA9OIt8UU9pY0lN0Fr3RR6mJwzPG6mVe0ihL2008owKCoeWe7d22JLH1Jhj1 > >										9
1570 //	        < 10 ; 18M ; JUL 2020 ; opt. ; - ; 0 ; 1,15323719633868 ; -1 ; -0,00025 ; 0,00025 ; -3,2 ; 0,4 ; -1,5 ; -1,1 ; 3,2 ; -5,3 ; 0,98 ; NABCNYJU2013 ; ACCDCc2deeCC4bC7DDCdB8FbbD961E44bF3bBcE5ddAC7eEeE19AAdCf0fA413EE ; < rD22agS9q4IU2FbPL6YDE6L70AoKTOybcW3bcTA4MM25Em34cfnv9RAR0BR422XB > >										10
1571 //	        < 11 ; 20M ; SEP 2020 ; opt. ; - ; 0 ; 1,15592473278381 ; -1 ; -0,00025 ; 0,00025 ; 4,6 ; -9,9 ; 4,7 ; -9,7 ; -0,5 ; -9,5 ; 0,51 ; NABCNYSE2084 ; Aa37CbE4aCAc30B2614FeDcC3Fc75423eF99b8eDC0A53DcdcC6AddfABE8A8725 ; < 683lRCz8K4tn2P0G1adTNZ03e1T15V4W97UJtS87s2CY122M2e40K2w1pMUPnt6B > >										11
1572 //	        < 12 ; 23M ; DEC 2020 ; opt. ; - ; 0 ; 1,15882725978783 ; -1 ; -0,00025 ; 0,00025 ; 8,3 ; 7,8 ; -2,4 ; 9,9 ; 8,8 ; 9,1 ; -0,16 ; NABCNYDE2024 ; CfCFd78c988Cb402f6aFc0BdfeAACDabFAc8CbcadAbac6aDdAB32cABFC12eBFE ; < 3wV37G6b0yfQXP7hoOEEE94u14i7Q1t4qnRMpXqar0ACTup0F9m91ll3vb0t6WZ2 > >										12
1573 //	        < 13 ; 24M ; JAN 2021 ; opt. ; - ; 0 ; 1,1619069767695 ; -1 ; -0,00025 ; 0,00025 ; -7,8 ; -7,6 ; -3,6 ; -4,9 ; 8,6 ; -1,4 ; 0,48 ; NABCNYJA2135 ; FEFfc7CC0fCeF52DeFadAABc6B0b9fc19dd17A0172cddA7B5fbaFb1Dc5E543eE ; < g6j72OP1NCJ7hSL1JWIhZKsGzgA3Z74E1q35aWic66K2GJQ7DvqPRLK2puS6K5N7 > >										13
1574 //	        < 14 ; 26M ; MAR 2021 ; opt. ; - ; 0 ; 1,16530819671831 ; -1 ; -0,00025 ; 0,00025 ; 6,8 ; -5,1 ; -2,8 ; 5,1 ; -2,5 ; 9,5 ; -0,6 ; NABCNYMA2159 ; 9dA7b7Ed9B54c6ecD3d8eDDEaFE7B352FDcedEbBbeF7F3dcD5bCEDF9bf1fCfc3 ; < DA33Sf075W65tqpGv6o3aier6qe9Ff33Ai5phyJ514sXml6EAdz1Q526Xq7133Gd > >										14
1575 //	        < 15 ; 28M ; MAY 2021 ; opt. ; - ; 0 ; 1,16903832023362 ; -1 ; -0,00025 ; 0,00025 ; 6,5 ; -4 ; -3,6 ; 8 ; 4,1 ; -3,8 ; -0,69 ; NABCNYMA2193 ; E5CA2EdCEbfCbDaC21ABBF6eB4bD5ADb8C4aFEF00bF7eCd0dC23Ffe9B3BaFDdf ; < o2wb9enLSJYxIiLu1N7Y8r75jFbd1ND028A0Q39lVZ387uVQVtFgaDfj6C4SM47p > >										15
1576 //	        < 16 ; 30M ; JUL 2021 ; opt. ; - ; 0 ; 1,17293790643596 ; -1 ; -0,00025 ; 0,00025 ; -1,4 ; -3,8 ; -5,3 ; -7,7 ; -3,7 ; -3,6 ; 0,73 ; NABCNYJU2119 ; 8DA5DAC9fFeB4A29dbABe0C5EfdcDAF9F0ecFaB55DA212DbFf9BadBAde6efbb7 ; < 1j3H5Mv1T9y9yZatR41AlPWzvg5M1rk2a4ZhsmZR5r297r7lze7IH0HEYPx7xp7A > >										16
1577 //	        < 17 ; 32M ; SEP 2021 ; opt. ; - ; 0 ; 1,17715756273991 ; -1 ; -0,00025 ; 0,00025 ; -5,7 ; 6,2 ; -5,9 ; -6,2 ; -8,9 ; 5,1 ; -0,78 ; NABCNYSE2194 ; 8aCFBF63ecFEDF9FA8B4F8d2A223FEbD41bAbdF6d55b940c6e7aDEaFEa447edC ; < l0A5OtztzB3FXEAWg3US0M7LOVV2DwffPWOwGMuuGwJYWXQHgXdaz5zC4SGz00ah > >										17
1578 //	        < 18 ; 35M ; DEC 2021 ; opt. ; - ; 0 ; 1,18146754007652 ; -1 ; -0,00025 ; 0,00025 ; -3,7 ; -9,9 ; -9,4 ; -2,7 ; 6,1 ; -3,8 ; 0,85 ; NABCNYDE2126 ; 96BF911B9FbbFE2BABCF3de329dfA1Ee6a7A9d9aE03bb158ddD77B6fE13d1eD1 ; < 7o1Z7fyB8zVpisPimcs6761x7nN3s6mMA9Hv8Kg8Um601hot1Wl0o3uk3PCsBztq > >										18
1579 //	        < 19 ; 36M ; JAN 2021 ; opt. ; - ; 0 ; 1,18614168395367 ; -1 ; -0,00025 ; 0,00025 ; -2,2 ; -8,9 ; -1,2 ; -2,2 ; -4,6 ; 6,4 ; -0,71 ; NABCNYJA2171 ; DFbedE0AE0013C7AaaC5A6eb59f9ceeEadEfeEb9dEf9c8Ca5fBc4da7AeA6C19D ; < uTy8gn6WgMdiVF13l3At3Puj8g2za7fha3462ypB6PkKYzFI254X1j7fuAgkyll6 > >										19
1580 //	        < 20 ; 38M ; MAR 2021 ; opt. ; - ; 0 ; 1,19119718340949 ; -1 ; -0,00025 ; 0,00025 ; 5,9 ; -8,2 ; 9,1 ; 3,4 ; 0,5 ; -2,1 ; -0,66 ; NABCNYMA2142 ; Ade71ADeE10C9caaC3eBB7fD450AdEaAbf0eCEEEC67e48bB7e9B40b8C5e55424 ; < 4lLyJsKpElf6AU13nG9i98zD0ZzkxhNXFT60Bi0nS53fE7Frt9TJw1UTmIGg5YTX > >										20
1581 //	        < 21 ; 40M ; MAY 2021 ; opt. ; - ; 0 ; 1,19645643893813 ; -1 ; -0,00025 ; 0,00025 ; 0,2 ; 8,3 ; -8,8 ; 3,9 ; 2,8 ; -4,9 ; -0,49 ; NABCNYMA2175 ; 7F2CABaa9CDD9e4BBBacFF2A9Fec2beCf919b5ba4DEcC9DeD7af4979DDC1Aa9d ; < o465vaEGkP4jxV046jPR698E6QfUL6wNqSMTz559uP90091V25ZAUKqE44gNgqFH > >										21
1582 //	        < 22 ; 42M ; JUL 2021 ; opt. ; - ; 0 ; 1,20189924727131 ; -1 ; -0,00025 ; 0,00025 ; -7,5 ; 4,6 ; -2,4 ; -9,6 ; 9,3 ; 4,5 ; -0,38 ; NABCNYJU2159 ; 8dAfc3bDc35e1fED2c8CCD4aafbFEcefdedBddFDbB29BBabbd0aB1B9EDa1BaAc ; < GU32kzM05GZL59VvRv825Z2dhzl0goXPMZ4N84vz7k36l1VKTLAO582o0Ok71v98 > >										22
1583 //	        < 23 ; 44M ; SEP 2021 ; opt. ; - ; 0 ; 1,20770100332001 ; -1 ; -0,00025 ; 0,00025 ; 4 ; 3,5 ; 8 ; -0,6 ; 4,7 ; -1 ; -0,66 ; NABCNYSE2122 ; 3dfccB7abEba4dcBb8dEcCaaccfdB1e0CadA3Eef4D33cfc3Fd4cAEFB8dacEdD0 ; < 47kI1e3v4r773628TG4Y38VfKc20k9P3YL9DA7R9UrQ08P7hOWyeC481A3tD6k7Z > >										23
1584 //	        < 24 ; 47M ; DEC 2021 ; opt. ; - ; 0 ; 1,21380381841504 ; -1 ; -0,00025 ; 0,00025 ; -0,3 ; 0,1 ; -3,7 ; 8,1 ; 0,3 ; -3,2 ; 0,94 ; NABCNYDE2171 ; AD5e5a3f0A9fBcb9aFcAd2Ef765d3FFffb4AFedBaBbAD9BBA9Fb4AAEE0B95F12 ; < M3w1D4447l4x7Z0hi8rp816U6KMu8oMI99T8CxOnEvxy92CYW2LgNiDWS4NeLdN7 > >										24
1585 											
1586 //	  < CALLS ; 24M ; Strike ; Symbol ; Last ; T(-1) ; Change ; Volume ; BAS_1 ; BAS_2 ; o.i. @ eth_hex ; @ btc_882 >										
1587 											
1588 //	#DIV/0 !										1
1589 //	#DIV/0 !										2
1590 //	#DIV/0 !										3
1591 //	#DIV/0 !										4
1592 //	#DIV/0 !										5
1593 //	#DIV/0 !										6
1594 //	#DIV/0 !										7
1595 //	#DIV/0 !										8
1596 //	#DIV/0 !										9
1597 //	#DIV/0 !										10
1598 //	#DIV/0 !										11
1599 //	#DIV/0 !										12
1600 //	#DIV/0 !										13
1601 //	#DIV/0 !										14
1602 //	#DIV/0 !										15
1603 //	#DIV/0 !										16
1604 //	#DIV/0 !										17
1605 //	#DIV/0 !										18
1606 //	#DIV/0 !										19
1607 //	#DIV/0 !										20
1608 //	#DIV/0 !										21
1609 //											
1610 //	  < PUTS ; 24M ; Strike ; Symbol ; Last ; T(-1) ; Change ; Volume ; BAS_1 ; BAS_2 ; o.i. @ eth_hex ; @ btc_882 >										
1611 //											
1612 //	#DIV/0 !										1
1613 //	#DIV/0 !										2
1614 //	#DIV/0 !										3
1615 //	#DIV/0 !										4
1616 //	#DIV/0 !										5
1617 //	#DIV/0 !										6
1618 //	#DIV/0 !										7
1619 //	#DIV/0 !										8
1620 //	#DIV/0 !										9
1621 //	#DIV/0 !										10
1622 //	#DIV/0 !										11
1623 //	#DIV/0 !										12
1624 //	#DIV/0 !										13
1625 //	#DIV/0 !										14
1626 //	#DIV/0 !										15
1627 //	#DIV/0 !										16
1628 //	#DIV/0 !										17
1629 //	#DIV/0 !										18
1630 //	#DIV/0 !										19
1631 //	#DIV/0 !										20
1632 //	#DIV/0 !										21
1633 											
1634 											
1635 											
1636 											
1637 											
1638 //	NABCNY										
1639 											
1640 //	  < # ; REF ; Month ; Optionchain ; Chart ; Last ; T(-1) ; Change ; BAS_1 ; BAS_2 ; Prior. Settle ; Open ; High ; Low ; Volume ; Hi / Lo ; Updated (s) ; Code ; @ eth_hex ; @ btc_882 >										
1641 											
1642 //	        < 0 ; T0 ; - ; - ; - ; 0 ; 1,14 ; -1 ; - ; - ; - ; - ; - ; - ; - ; - ; - ; - ; 161bF94D215ACAD73A0058eF56DEdc8a0EBE8aD3aC9b5D8C0EfCBceaf5eddde9 ; < p0lVtq04AW915sCuurd9IMo7ewAd02z5XuO8AZ899704v6BmU47xYIJZ31BIpeD1 > >										0
1643 //	        < 1 ; 0M ; JAN 2019 ; opt. ; - ; 0 ; 1,14013006829845 ; -1 ; -0,00025 ; 0,00025 ; -4,7 ; -8 ; 1,6 ; -6,4 ; -2,2 ; 5 ; -0,33 ; NABCNY63JA19 ; D5CcdeC0dBafEb4EaA8bF25E5eBB81eCAAB6eDfeecffAA9B9DEa21ddaBeBdfd0 ; < sPy4Ie2907w1OC892rVqS2b46rCkA82BauCob0qY3551nHXgfysy7SiI6qr6HPG2 > >										1
1644 //	        < 2 ; 2M ; MAR 2019 ; opt. ; - ; 0 ; 1,14050657721427 ; -1 ; -0,00025 ; 0,00025 ; -3,7 ; -9,8 ; 6 ; 9 ; 2,3 ; -6,5 ; -0,94 ; NABCNYMA1919 ; 3FE89Da5C79AcB527d3005b4EEBCEA7DE00E876D51dc6Ff4BDF2AEfD9FEFf9e5 ; < 5T6Dh67YAH7KW85Mz6xwR22dzec3AcZ4v665J8r90P2pzy5g8wdqnXL44f973f6u > >										2
1645 //	        < 3 ; 4M ; MAY 2019 ; opt. ; - ; 0 ; 1,1412403961573 ; -1 ; -0,00025 ; 0,00025 ; 6,1 ; -8,9 ; -1 ; 2,4 ; -0,8 ; -3,6 ; -0,81 ; NABCNYMA1913 ; aaaDcBCEf8d3BfCb78116D7D631aaE82DDABCCE4B9fC3d14deE0CBfafeB9d5d8 ; < lTs2X2R2l2Bnqy0mSR8Ozke60QMh85g58Syj5F8MNUT4AaHBhkoMNE1Zlozev5oI > >										3
1646 //	        < 4 ; 6M ; JUL 2019 ; opt. ; - ; 0 ; 1,14215525993933 ; -1 ; -0,00025 ; 0,00025 ; -9,4 ; -4,6 ; -3,9 ; 8,4 ; 3,9 ; 1,2 ; 0,65 ; NABCNYJU1976 ; ccCA7CEDb3E1E1E5AC4FF643b8DAf5912CaBBA70454aCEEF499Ec24DeDB6c236 ; < 432VWTUx6hi6NcQDdr9Tv41312wj0kOb192AKpje19XkypR9iH0o2oS1NzT48QCy > >										4
1647 //	        < 5 ; 8M ; SEP 2019 ; opt. ; - ; 0 ; 1,14344236397449 ; -1 ; -0,00025 ; 0,00025 ; 8,6 ; -9,9 ; 6,3 ; 1,1 ; 9,3 ; -8,5 ; -0,99 ; NABCNYSE1988 ; BaBCECC0DFaEA9ACFbE8142cFb4e0e9ce7DB5Ce1c9cF02A83eC2a8AEFfDf7f0a ; < tXm4UQlCP275o5JDzbzw7YINcn916if9ds0K29fDVYbq4Uso0SX3OhV2luF0QH5Y > >										5
1648 //	        < 6 ; 11M ; DEC 2019 ; opt. ; - ; 0 ; 1,14496911077331 ; -1 ; -0,00025 ; 0,00025 ; -6,9 ; 7,8 ; -3,2 ; -4,8 ; -3,5 ; -1,1 ; -0,37 ; NABCNYDE1951 ; ADD9EbCecA8438CcDe94BbAB1E7DAF3cFd4daab21fc9efD3abEbcA63C7BcbDb2 ; < U63652m61QS6k92NGJv4Q32MC3k2Z61t30l8RjBiX9N7Fd1jh1Rsrw6Egkbtrl42 > >										6
1649 //	        < 7 ; 12M ; JAN 2020 ; opt. ; - ; 0 ; 1,14671813659638 ; -1 ; -0,00025 ; 0,00025 ; 5,7 ; -4,2 ; 2,5 ; -2,7 ; 6,4 ; 3,7 ; 0,87 ; NABCNYJA2019 ; 1C7fB2eEcAbB127Ef51258CeDedFB9Cbe6A4a27Ff2AB32c3FEa70DC0Ff1DfAED ; < 49e0T6etNJX15426TrFIG0CDHsu8Cy9PCDLx8gv197X0M9LdmJC1xSPE78B8ao2H > >										7
1650 //	        < 8 ; 14M ; MAR 2020 ; opt. ; - ; 0 ; 1,1486789936402 ; -1 ; -0,00025 ; 0,00025 ; 2,3 ; 3 ; 8,2 ; -3,4 ; 9,2 ; -9,5 ; 0,66 ; NABCNYMA2034 ; 6DceAaECEfca15DD8FfcEbCdAD98b6fBCB0fa4Fc4dBEe6B34eBAEF2dEf1eEfDe ; < 0DUz3452QlPjWBd1G19zRAtO92C917AFOABHb5422IlwCe98W13dc9xnIt60TWeb > >										8
1651 //	        < 9 ; 16M ; MAY 2020 ; opt. ; - ; 0 ; 1,15075513290672 ; -1 ; -0,00025 ; 0,00025 ; -7 ; 6,2 ; 9,4 ; -6,4 ; -3,5 ; 0,4 ; -0,08 ; NABCNYMA2082 ; 7F0769eeCCaFae5EfA9c6a6Ef0cA5C8de1BeEE7AdCcFcebE1A247f6adad07CBa ; < PE4cFA9OIt8UU9pY0lN0Fr3RR6mJwzPG6mVe0ihL2008owKCoeWe7d22JLH1Jhj1 > >										9
1652 //	        < 10 ; 18M ; JUL 2020 ; opt. ; - ; 0 ; 1,15323719633868 ; -1 ; -0,00025 ; 0,00025 ; -3,2 ; 0,4 ; -1,5 ; -1,1 ; 3,2 ; -5,3 ; 0,98 ; NABCNYJU2013 ; ACCDCc2deeCC4bC7DDCdB8FbbD961E44bF3bBcE5ddAC7eEeE19AAdCf0fA413EE ; < rD22agS9q4IU2FbPL6YDE6L70AoKTOybcW3bcTA4MM25Em34cfnv9RAR0BR422XB > >										10
1653 //	        < 11 ; 20M ; SEP 2020 ; opt. ; - ; 0 ; 1,15592473278381 ; -1 ; -0,00025 ; 0,00025 ; 4,6 ; -9,9 ; 4,7 ; -9,7 ; -0,5 ; -9,5 ; 0,51 ; NABCNYSE2084 ; Aa37CbE4aCAc30B2614FeDcC3Fc75423eF99b8eDC0A53DcdcC6AddfABE8A8725 ; < 683lRCz8K4tn2P0G1adTNZ03e1T15V4W97UJtS87s2CY122M2e40K2w1pMUPnt6B > >										11
1654 //	        < 12 ; 23M ; DEC 2020 ; opt. ; - ; 0 ; 1,15882725978783 ; -1 ; -0,00025 ; 0,00025 ; 8,3 ; 7,8 ; -2,4 ; 9,9 ; 8,8 ; 9,1 ; -0,16 ; NABCNYDE2024 ; CfCFd78c988Cb402f6aFc0BdfeAACDabFAc8CbcadAbac6aDdAB32cABFC12eBFE ; < 3wV37G6b0yfQXP7hoOEEE94u14i7Q1t4qnRMpXqar0ACTup0F9m91ll3vb0t6WZ2 > >										12
1655 //	        < 13 ; 24M ; JAN 2021 ; opt. ; - ; 0 ; 1,1619069767695 ; -1 ; -0,00025 ; 0,00025 ; -7,8 ; -7,6 ; -3,6 ; -4,9 ; 8,6 ; -1,4 ; 0,48 ; NABCNYJA2135 ; FEFfc7CC0fCeF52DeFadAABc6B0b9fc19dd17A0172cddA7B5fbaFb1Dc5E543eE ; < g6j72OP1NCJ7hSL1JWIhZKsGzgA3Z74E1q35aWic66K2GJQ7DvqPRLK2puS6K5N7 > >										13
1656 //	        < 14 ; 26M ; MAR 2021 ; opt. ; - ; 0 ; 1,16530819671831 ; -1 ; -0,00025 ; 0,00025 ; 6,8 ; -5,1 ; -2,8 ; 5,1 ; -2,5 ; 9,5 ; -0,6 ; NABCNYMA2159 ; 9dA7b7Ed9B54c6ecD3d8eDDEaFE7B352FDcedEbBbeF7F3dcD5bCEDF9bf1fCfc3 ; < DA33Sf075W65tqpGv6o3aier6qe9Ff33Ai5phyJ514sXml6EAdz1Q526Xq7133Gd > >										14
1657 //	        < 15 ; 28M ; MAY 2021 ; opt. ; - ; 0 ; 1,16903832023362 ; -1 ; -0,00025 ; 0,00025 ; 6,5 ; -4 ; -3,6 ; 8 ; 4,1 ; -3,8 ; -0,69 ; NABCNYMA2193 ; E5CA2EdCEbfCbDaC21ABBF6eB4bD5ADb8C4aFEF00bF7eCd0dC23Ffe9B3BaFDdf ; < o2wb9enLSJYxIiLu1N7Y8r75jFbd1ND028A0Q39lVZ387uVQVtFgaDfj6C4SM47p > >										15
1658 //	        < 16 ; 30M ; JUL 2021 ; opt. ; - ; 0 ; 1,17293790643596 ; -1 ; -0,00025 ; 0,00025 ; -1,4 ; -3,8 ; -5,3 ; -7,7 ; -3,7 ; -3,6 ; 0,73 ; NABCNYJU2119 ; 8DA5DAC9fFeB4A29dbABe0C5EfdcDAF9F0ecFaB55DA212DbFf9BadBAde6efbb7 ; < 1j3H5Mv1T9y9yZatR41AlPWzvg5M1rk2a4ZhsmZR5r297r7lze7IH0HEYPx7xp7A > >										16
1659 //	        < 17 ; 32M ; SEP 2021 ; opt. ; - ; 0 ; 1,17715756273991 ; -1 ; -0,00025 ; 0,00025 ; -5,7 ; 6,2 ; -5,9 ; -6,2 ; -8,9 ; 5,1 ; -0,78 ; NABCNYSE2194 ; 8aCFBF63ecFEDF9FA8B4F8d2A223FEbD41bAbdF6d55b940c6e7aDEaFEa447edC ; < l0A5OtztzB3FXEAWg3US0M7LOVV2DwffPWOwGMuuGwJYWXQHgXdaz5zC4SGz00ah > >										17
1660 //	        < 18 ; 35M ; DEC 2021 ; opt. ; - ; 0 ; 1,18146754007652 ; -1 ; -0,00025 ; 0,00025 ; -3,7 ; -9,9 ; -9,4 ; -2,7 ; 6,1 ; -3,8 ; 0,85 ; NABCNYDE2126 ; 96BF911B9FbbFE2BABCF3de329dfA1Ee6a7A9d9aE03bb158ddD77B6fE13d1eD1 ; < 7o1Z7fyB8zVpisPimcs6761x7nN3s6mMA9Hv8Kg8Um601hot1Wl0o3uk3PCsBztq > >										18
1661 //	        < 19 ; 36M ; JAN 2021 ; opt. ; - ; 0 ; 1,18614168395367 ; -1 ; -0,00025 ; 0,00025 ; -2,2 ; -8,9 ; -1,2 ; -2,2 ; -4,6 ; 6,4 ; -0,71 ; NABCNYJA2171 ; DFbedE0AE0013C7AaaC5A6eb59f9ceeEadEfeEb9dEf9c8Ca5fBc4da7AeA6C19D ; < uTy8gn6WgMdiVF13l3At3Puj8g2za7fha3462ypB6PkKYzFI254X1j7fuAgkyll6 > >										19
1662 //	        < 20 ; 38M ; MAR 2021 ; opt. ; - ; 0 ; 1,19119718340949 ; -1 ; -0,00025 ; 0,00025 ; 5,9 ; -8,2 ; 9,1 ; 3,4 ; 0,5 ; -2,1 ; -0,66 ; NABCNYMA2142 ; Ade71ADeE10C9caaC3eBB7fD450AdEaAbf0eCEEEC67e48bB7e9B40b8C5e55424 ; < 4lLyJsKpElf6AU13nG9i98zD0ZzkxhNXFT60Bi0nS53fE7Frt9TJw1UTmIGg5YTX > >										20
1663 //	        < 21 ; 40M ; MAY 2021 ; opt. ; - ; 0 ; 1,19645643893813 ; -1 ; -0,00025 ; 0,00025 ; 0,2 ; 8,3 ; -8,8 ; 3,9 ; 2,8 ; -4,9 ; -0,49 ; NABCNYMA2175 ; 7F2CABaa9CDD9e4BBBacFF2A9Fec2beCf919b5ba4DEcC9DeD7af4979DDC1Aa9d ; < o465vaEGkP4jxV046jPR698E6QfUL6wNqSMTz559uP90091V25ZAUKqE44gNgqFH > >										21
1664 //	        < 22 ; 42M ; JUL 2021 ; opt. ; - ; 0 ; 1,20189924727131 ; -1 ; -0,00025 ; 0,00025 ; -7,5 ; 4,6 ; -2,4 ; -9,6 ; 9,3 ; 4,5 ; -0,38 ; NABCNYJU2159 ; 8dAfc3bDc35e1fED2c8CCD4aafbFEcefdedBddFDbB29BBabbd0aB1B9EDa1BaAc ; < GU32kzM05GZL59VvRv825Z2dhzl0goXPMZ4N84vz7k36l1VKTLAO582o0Ok71v98 > >										22
1665 //	        < 23 ; 44M ; SEP 2021 ; opt. ; - ; 0 ; 1,20770100332001 ; -1 ; -0,00025 ; 0,00025 ; 4 ; 3,5 ; 8 ; -0,6 ; 4,7 ; -1 ; -0,66 ; NABCNYSE2122 ; 3dfccB7abEba4dcBb8dEcCaaccfdB1e0CadA3Eef4D33cfc3Fd4cAEFB8dacEdD0 ; < 47kI1e3v4r773628TG4Y38VfKc20k9P3YL9DA7R9UrQ08P7hOWyeC481A3tD6k7Z > >										23
1666 //	        < 24 ; 47M ; DEC 2021 ; opt. ; - ; 0 ; 1,21380381841504 ; -1 ; -0,00025 ; 0,00025 ; -0,3 ; 0,1 ; -3,7 ; 8,1 ; 0,3 ; -3,2 ; 0,94 ; NABCNYDE2171 ; AD5e5a3f0A9fBcb9aFcAd2Ef765d3FFffb4AFedBaBbAD9BBA9Fb4AAEE0B95F12 ; < M3w1D4447l4x7Z0hi8rp816U6KMu8oMI99T8CxOnEvxy92CYW2LgNiDWS4NeLdN7 > >										24
1667 											
1668 //	  < CALLS ; 36M ; Strike ; Symbol ; Last ; T(-1) ; Change ; Volume ; BAS_1 ; BAS_2 ; o.i. @ eth_hex ; @ btc_882 >										
1669 											
1670 //	#DIV/0 !										1
1671 //	#DIV/0 !										2
1672 //	#DIV/0 !										3
1673 //	#DIV/0 !										4
1674 //	#DIV/0 !										5
1675 //	#DIV/0 !										6
1676 //	#DIV/0 !										7
1677 //	#DIV/0 !										8
1678 //	#DIV/0 !										9
1679 //	#DIV/0 !										10
1680 //	#DIV/0 !										11
1681 //	#DIV/0 !										12
1682 //	#DIV/0 !										13
1683 //	#DIV/0 !										14
1684 //	#DIV/0 !										15
1685 //	#DIV/0 !										16
1686 //	#DIV/0 !										17
1687 //	#DIV/0 !										18
1688 //	#DIV/0 !										19
1689 //	#DIV/0 !										20
1690 //	#DIV/0 !										21
1691 //											
1692 //	  < PUTS ; 36M ; Strike ; Symbol ; Last ; T(-1) ; Change ; Volume ; BAS_1 ; BAS_2 ; o.i. @ eth_hex ; @ btc_882 >										
1693 //											
1694 //	#DIV/0 !										1
1695 //	#DIV/0 !										2
1696 //	#DIV/0 !										3
1697 //	#DIV/0 !										4
1698 //	#DIV/0 !										5
1699 //	#DIV/0 !										6
1700 //	#DIV/0 !										7
1701 //	#DIV/0 !										8
1702 //	#DIV/0 !										9
1703 //	#DIV/0 !										10
1704 //	#DIV/0 !										11
1705 //	#DIV/0 !										12
1706 //	#DIV/0 !										13
1707 //	#DIV/0 !										14
1708 //	#DIV/0 !										15
1709 //	#DIV/0 !										16
1710 //	#DIV/0 !										17
1711 //	#DIV/0 !										18
1712 //	#DIV/0 !										19
1713 //	#DIV/0 !										20
1714 //	#DIV/0 !										21
1715 											
1716 											
1717 											
1718 											
1719 											
1720 //	NABETH										
1721 											
1722 //	  < # ; REF ; Month ; Optionchain ; Chart ; Last ; T(-1) ; Change ; BAS_1 ; BAS_2 ; Prior. Settle ; Open ; High ; Low ; Volume ; Hi / Lo ; Updated (s) ; Code ; @ eth_hex ; @ btc_882 >										
1723 											
1724 //	        < 0 ; T0 ; - ; - ; - ; 0 ; 1,14 ; -1 ; - ; - ; - ; - ; - ; - ; - ; - ; - ; - ; c46dFe0BcdDbC242FCcffEfe7adEDb875fceE771dcdC74Ff9Eb380bdD9efDe7A ; < QmUiLtY4zThGlnc1nJ2DGdYQw7r8240UhM78Efgvv0U79C13zp4hW216opNi3hb1 > >										0
1725 //	        < 1 ; 0M ; JAN 2019 ; opt. ; - ; 0 ; 1,14024520829845 ; -1 ; -0,00025 ; 0,00025 ; -0,1 ; -6,3 ; -6,3 ; 0,2 ; 8,4 ; 3,8 ; -0,62 ; NABETH45JA19 ; 79C41e7D8c24974e6dD7c8d87CBbd0Bc0AdE5abFB7EbBbfFFdDFDccB22bFba13 ; < yrv7q09CRZpc9y55DI8Ec2DNN33p0bB5IPDOQxkmxPAU83K5B9rI9hKpu6SO8A7j > >										1
1726 //	        < 2 ; 2M ; MAR 2019 ; opt. ; - ; 0 ; 1,14066622480045 ; -1 ; -0,00025 ; 0,00025 ; -0,1 ; 1 ; -1,1 ; 4 ; -1,4 ; -6,5 ; 0,76 ; NABETHMA1928 ; DcAcBD1EBEF83ae2BDacdAeA21EAB85b044dDCafF1AccEAe1bcFABbB99CbD0cB ; < 3sfvlNKPMyXDXE3IN1OvD4Kb4glfnAw7lE9y1aqM55I5BD61rI5oQgTxabC5CvT0 > >										2
1727 //	        < 3 ; 4M ; MAY 2019 ; opt. ; - ; 0 ; 1,14145489844192 ; -1 ; -0,00025 ; 0,00025 ; 4,9 ; -7,8 ; -4,6 ; -7,6 ; 8,9 ; -9,8 ; 0,63 ; NABETHMA1962 ; E8c9cCccaBacFdccbc5cE54BFcA5BbBBCDBB7Fab6e20Fac16dE6e0Faca82d0e7 ; < 5sGtT7W5TwXnA4mAC9vvbs9Rg0Lez4S7A4X7DUl6hPO59MEbvD5KB0H3tC6Z8xZ7 > >										3
1728 //	        < 4 ; 6M ; JUL 2019 ; opt. ; - ; 0 ; 1,14236650981283 ; -1 ; -0,00025 ; 0,00025 ; 0 ; -4,4 ; -8,4 ; -1,7 ; 8 ; 0,1 ; -0,59 ; NABETHJU1995 ; Ea359E7B2baaD89e40524bD3FcA3E51524adCb9A6DBFBd50bDdac2c7Bc3977A7 ; < iJAEK75E0Ubv76Bx008GgS8gs59uxF6lb70YM5enfP1HE60O1wuin1NySixqS0D6 > >										4
1729 //	        < 5 ; 8M ; SEP 2019 ; opt. ; - ; 0 ; 1,14364357060859 ; -1 ; -0,00025 ; 0,00025 ; -9,4 ; -7,6 ; 2,7 ; -9,1 ; 8,5 ; 3,6 ; -0,41 ; NABETHSE1971 ; 4df5dEFbf3B55A34fcc9cEa4eBCE2eCcA4BdAf38cd90EeF03d26e1FAfeeEDEa9 ; < 52rKCozn97zA5MoQ7824Z2p1nLq4oX1rYupZ457g5yapQdjVw67lG33dp0bXY592 > >										5
1730 //	        < 6 ; 11M ; DEC 2019 ; opt. ; - ; 0 ; 1,14505850899257 ; -1 ; -0,00025 ; 0,00025 ; 4,5 ; 1,6 ; 1,9 ; -5,2 ; -8,3 ; -8,8 ; -0,39 ; NABETHDE1947 ; 6CECc2cD0Fa0CE9f9CF51AcDF9a8B4fAA0c3ED7EbA38B8c7b7fb23acD3cdE264 ; < Iddzjt1owEOidFRx17GlTeT2KuBF3E78lQO02q5NYB5011K14baC58w6L4K63Giv > >										6
1731 //	        < 7 ; 12M ; JAN 2020 ; opt. ; - ; 0 ; 1,1468088164366 ; -1 ; -0,00025 ; 0,00025 ; -0,5 ; -0,7 ; -1 ; -1,3 ; 0 ; -2,2 ; 0,75 ; NABETHJA2038 ; 2755a3b07Dbb6fe8BfDdCB5ceFC5acdADE0f114F37fEDC2F1b40C7eb1ddE38cc ; < c2nz3p653X412mg96Wk5zf8c1b40rruC2W8i35U3yz0r8jdHliVP4L1hwfcHlF2x > >										7
1732 //	        < 8 ; 14M ; MAR 2020 ; opt. ; - ; 0 ; 1,14870675405559 ; -1 ; -0,00025 ; 0,00025 ; -0,3 ; 3 ; 3,4 ; 1,3 ; 1,9 ; -4,9 ; -0,68 ; NABETHMA2031 ; 4d46f4adD81d1642EdcCa35CB87D1B9CC8c0B3B8Bd1AbB4efd5959e0bF83DF7d ; < c5Ph61U21D0Unfx8Mgf48C09GrD5J6ucSKPII2eGjzBY8CXq0J2cvTW85T1n2P16 > >										8
1733 //	        < 9 ; 16M ; MAY 2020 ; opt. ; - ; 0 ; 1,1508851783978 ; -1 ; -0,00025 ; 0,00025 ; -7,8 ; 2,3 ; -5 ; 8,1 ; 2,1 ; -5,6 ; -0,28 ; NABETHMA2082 ; cFcAbc9cd979fBEabCEE27bA1fb8e894eDbDdDFdcEdd05Eb3ABE7bb7e1ca0DfA ; < rqAyF2sWK93VZ2dKiS3xUVZe1wtvVm36YNBc7kqjdeyCNL62UrOEuziJhI1T0k0e > >										9
1734 //	        < 10 ; 18M ; JUL 2020 ; opt. ; - ; 0 ; 1,15322826521826 ; -1 ; -0,00025 ; 0,00025 ; -9,6 ; -1,5 ; -4,5 ; -4,8 ; 4,5 ; 9,8 ; -0,71 ; NABETHJU2056 ; 67Bd2dBed3494Ffcfad21A61bebBDADfDC7Fe6Fd939Dfcca06FAafEC83AFd394 ; < 2mw08Ah2d6acW03CMM80fxats5NCBScv9o7ZzL71Fsm2a2clHA4YWzgMp1vRA9rj > >										10
1735 //	        < 11 ; 20M ; SEP 2020 ; opt. ; - ; 0 ; 1,15581199030619 ; -1 ; -0,00025 ; 0,00025 ; 9,2 ; 4,6 ; 8,5 ; -5,7 ; -8 ; -1 ; -0,55 ; NABETHSE2052 ; f2b175edCBfb0eeAeEc83c6edF24bEdfe749A3de6C97bbcee4daAAcCbae6679F ; < WdeMg185lKS5ShGb383R1kZy22IWxkpa92dOc4dhLd6y8V8xfV3xR8F2Hvprvnzm > >										11
1736 //	        < 12 ; 23M ; DEC 2020 ; opt. ; - ; 0 ; 1,15859402976686 ; -1 ; -0,00025 ; 0,00025 ; -4,2 ; -5,9 ; 3,6 ; -0,4 ; 7 ; -8,9 ; -0,6 ; NABETHDE2069 ; 66745Bb6e3b4ffC19Ae6CfC2ed0bBbCABfeDa5A3beBaE5BA2C4AE1882D3ceD8F ; < 7Reve50cr2qveV4NoiOJ77qH0qUM7I93LOLahuda2bMojR1EkGJH5747P0S2CsSo > >										12
1737 //	        < 13 ; 24M ; JAN 2021 ; opt. ; - ; 0 ; 1,1616314175278 ; -1 ; -0,00025 ; 0,00025 ; 3,4 ; -4,4 ; 9,1 ; -6,1 ; 5,6 ; -3,9 ; -0,76 ; NABETHJA2183 ; fAddebC2a1Ced0C3F8Da9a4Fa004B4Bb557DACCD172DBDAe1a80cF32A91fBcd7 ; < 702OiSygi1357Goesgb7u8MxM3Xu5OHn4F8OU59x9zUJ233JQT210f5NVYg71m2j > >										13
1738 //	        < 14 ; 26M ; MAR 2021 ; opt. ; - ; 0 ; 1,16498188068828 ; -1 ; -0,00025 ; 0,00025 ; 6,2 ; 0 ; 7,8 ; -7,5 ; 7,5 ; 9,8 ; 0,13 ; NABETHMA2171 ; 7a4aAFAeBBD1878cdca13bE0cBbB9A0aa60AdCe69E46BeC9e8EB5E1B419C7fdC ; < 2q058Ox13HY87m44hvX70wC56Tc81290W3ZGft5H6Cvk2eT811pq9F6bc1650sGX > >										14
1739 //	        < 15 ; 28M ; MAY 2021 ; opt. ; - ; 0 ; 1,16865387556168 ; -1 ; -0,00025 ; 0,00025 ; -9 ; -7,2 ; -0,6 ; 6,4 ; -9,3 ; -9,3 ; -0,11 ; NABETHMA2177 ; bcB3CAB5daDC0D2625F15Ffd8cabcB8a2e30f0fEAB90C9c9FcCa2EaEac071a5F ; < Ypfv6XBO8xMP4KObkC0N9z35gtx6JqwX6ourv34488Kl692G7b0l8Y3VSzV3JNC5 > >										15
1740 //	        < 16 ; 30M ; JUL 2021 ; opt. ; - ; 0 ; 1,17258840763381 ; -1 ; -0,00025 ; 0,00025 ; 1,5 ; -4,9 ; 1,8 ; 1,8 ; -1,9 ; -5,5 ; 0,13 ; NABETHJU2164 ; 952ad6AAbf1edF6fA928Ddbd0cDBCf195Fb9cEBe2A54aBa43Ce2CFE7cB5bBa9e ; < dU18045tiz1MsG8aKC2465E42K0712o74LQMsJb4PmRvMQ60SzPx95D8Tkqxw03v > >										16
1741 //	        < 17 ; 32M ; SEP 2021 ; opt. ; - ; 0 ; 1,17664967976558 ; -1 ; -0,00025 ; 0,00025 ; -9,4 ; -8,1 ; 3 ; 5,3 ; -7 ; 8 ; 0,08 ; NABETHSE2199 ; d9Eb9fc1db15db9Adc136AEadBc3b7E9baDDE0EafbB39e8e8597ebb0EC534a2a ; < VKK07sCndFz66ql3b4237i24RG0V83DWsv1o568dQB49s5lLfH8wz1lLUxI1u68w > >										17
1742 //	        < 18 ; 35M ; DEC 2021 ; opt. ; - ; 0 ; 1,1810354564474 ; -1 ; -0,00025 ; 0,00025 ; 2,2 ; 5,3 ; 2,3 ; -8,3 ; -2,5 ; 9 ; 0,49 ; NABETHDE2192 ; 2B2eD30DFDBb88C3fA315dF0E7b4A1331Fa2AD71B0db03305fC32AF3532DbC72 ; < JMaHybwD6VNFJthj2EZ7ju8dvpXBPAtFB16Xwnn1xb8U6VrEV40zC629pTktMGaU > >										18
1743 //	        < 19 ; 36M ; JAN 2021 ; opt. ; - ; 0 ; 1,18570670987179 ; -1 ; -0,00025 ; 0,00025 ; 0,3 ; 1,3 ; -4,5 ; -6,8 ; 6,1 ; 9,1 ; 0,38 ; NABETHJA2155 ; bEeD0BC2a2cEc41bcbecA3BbaED46AF0bD59f4Ae4DcAC29C09DD5aaF06F8ab41 ; < Kn2yg13dkc8499i3Rw7ATZcv8mT8pqm0ZhtK84U05712huT8giNjc0I55nle9yT3 > >										19
1744 //	        < 20 ; 38M ; MAR 2021 ; opt. ; - ; 0 ; 1,19065601321761 ; -1 ; -0,00025 ; 0,00025 ; 3,8 ; 6,1 ; 7,7 ; 2,6 ; -9,4 ; 2,4 ; -0,31 ; NABETHMA2181 ; bbDe6bbbcFe2BdbEa3B8aFCfFE5fCfcDaCdDCCe1f9666bBfBadbd1A9DcdCfC35 ; < 6hVaA5f2Pr1ae1JFXLg5452c7smAXJEkz1CuBFQD7TIv30v3R2Tjj8wCp5H0q9M4 > >										20
1745 //	        < 21 ; 40M ; MAY 2021 ; opt. ; - ; 0 ; 1,19580452972815 ; -1 ; -0,00025 ; 0,00025 ; -9,2 ; -7 ; 8,8 ; 6,3 ; -2 ; 9,1 ; -0,8 ; NABETHMA2194 ; EAA8F32c1DCE3Acd3FBA0e8D30DE032fB5a06cD5dAEe0fc9D5E99be8deA0be6A ; < 7IyUUYo2M7k4gw95N3aZu1O596JbXC0I8w89NTbM9nHSJ2YBKMn1ps01UK73SudD > >										21
1746 //	        < 22 ; 42M ; JUL 2021 ; opt. ; - ; 0 ; 1,20122523958412 ; -1 ; -0,00025 ; 0,00025 ; 3 ; 3,6 ; -7,7 ; -2,5 ; 5,2 ; -5,8 ; -0,73 ; NABETHJU2120 ; AA015D8cc3ce74A16DB3FA9FEABb13733cDDFB6ebd1BeAAED3Fdb5cACFEfaa8c ; < UQ10B3C66OQXeZ8jJ4d6J7cnxy4DRJSNL9u6QOjvUFONOiecs483m4AU9qG2t5Pw > >										22
1747 //	        < 23 ; 44M ; SEP 2021 ; opt. ; - ; 0 ; 1,20697088818153 ; -1 ; -0,00025 ; 0,00025 ; -9,4 ; -8,5 ; -4,9 ; -3,1 ; -4,2 ; 3,7 ; 0,92 ; NABETHSE2119 ; 83B4D10b2C6d67A92fcFea4ABDdDBA5D3b5eDec77ebC409cdCaca6Ac28f4e04e ; < 3DXYCv5STs94OA97Z7RpsT2wYr1vtkm60uF5nYLJxtGbyqOWb09kK476USXg8TiX > >										23
1748 //	        < 24 ; 47M ; DEC 2021 ; opt. ; - ; 0 ; 1,21309173929822 ; -1 ; -0,00025 ; 0,00025 ; 0,6 ; -7,5 ; 1,4 ; -8,1 ; -9,6 ; -2,5 ; 0,68 ; NABETHDE2151 ; d3eCfccC5feFebaAcbf36c3BDc51ce8eEe6edcB9c6d9DdDA0F1f9dBb6FACBcd1 ; < td1DP04x0GskJ30Ur579Mw7k31pn4Og1um5611ANuQqiajeu98J5ZT351o0THHgc > >										24
1749 											
1750 //	  < CALLS ; 3M ; Strike ; Symbol ; Last ; T(-1) ; Change ; Volume ; BAS_1 ; BAS_2 ; o.i. @ eth_hex ; @ btc_882 >										
1751 											
1752 //	#DIV/0 !										1
1753 //	#DIV/0 !										2
1754 //	#DIV/0 !										3
1755 //	#DIV/0 !										4
1756 //	#DIV/0 !										5
1757 //	#DIV/0 !										6
1758 //	#DIV/0 !										7
1759 //	#DIV/0 !										8
1760 //	#DIV/0 !										9
1761 //	#DIV/0 !										10
1762 //	#DIV/0 !										11
1763 //	#DIV/0 !										12
1764 //	#DIV/0 !										13
1765 //	#DIV/0 !										14
1766 //	#DIV/0 !										15
1767 //	#DIV/0 !										16
1768 //	#DIV/0 !										17
1769 //	#DIV/0 !										18
1770 //	#DIV/0 !										19
1771 //	#DIV/0 !										20
1772 //	#DIV/0 !										21
1773 //											
1774 //	  < PUTS ; 3M ; Strike ; Symbol ; Last ; T(-1) ; Change ; Volume ; BAS_1 ; BAS_2 ; o.i. @ eth_hex ; @ btc_882 >										
1775 //											
1776 //	#DIV/0 !										1
1777 //	#DIV/0 !										2
1778 //	#DIV/0 !										3
1779 //	#DIV/0 !										4
1780 //	#DIV/0 !										5
1781 //	#DIV/0 !										6
1782 //	#DIV/0 !										7
1783 //	#DIV/0 !										8
1784 //	#DIV/0 !										9
1785 //	#DIV/0 !										10
1786 //	#DIV/0 !										11
1787 //	#DIV/0 !										12
1788 //	#DIV/0 !										13
1789 //	#DIV/0 !										14
1790 //	#DIV/0 !										15
1791 //	#DIV/0 !										16
1792 //	#DIV/0 !										17
1793 //	#DIV/0 !										18
1794 //	#DIV/0 !										19
1795 //	#DIV/0 !										20
1796 //	#DIV/0 !										21
1797 											
1798 											
1799 											
1800 											
1801 											
1802 //	NABETH										
1803 											
1804 //	  < # ; REF ; Month ; Optionchain ; Chart ; Last ; T(-1) ; Change ; BAS_1 ; BAS_2 ; Prior. Settle ; Open ; High ; Low ; Volume ; Hi / Lo ; Updated (s) ; Code ; @ eth_hex ; @ btc_882 >										
1805 											
1806 //	        < 0 ; T0 ; - ; - ; - ; 0 ; 1,14 ; -1 ; - ; - ; - ; - ; - ; - ; - ; - ; - ; - ; c46dFe0BcdDbC242FCcffEfe7adEDb875fceE771dcdC74Ff9Eb380bdD9efDe7A ; < QmUiLtY4zThGlnc1nJ2DGdYQw7r8240UhM78Efgvv0U79C13zp4hW216opNi3hb1 > >										0
1807 //	        < 1 ; 0M ; JAN 2019 ; opt. ; - ; 0 ; 1,14024520829845 ; -1 ; -0,00025 ; 0,00025 ; -0,1 ; -6,3 ; -6,3 ; 0,2 ; 8,4 ; 3,8 ; -0,62 ; NABETH45JA19 ; 79C41e7D8c24974e6dD7c8d87CBbd0Bc0AdE5abFB7EbBbfFFdDFDccB22bFba13 ; < yrv7q09CRZpc9y55DI8Ec2DNN33p0bB5IPDOQxkmxPAU83K5B9rI9hKpu6SO8A7j > >										1
1808 //	        < 2 ; 2M ; MAR 2019 ; opt. ; - ; 0 ; 1,14066622480045 ; -1 ; -0,00025 ; 0,00025 ; -0,1 ; 1 ; -1,1 ; 4 ; -1,4 ; -6,5 ; 0,76 ; NABETHMA1928 ; DcAcBD1EBEF83ae2BDacdAeA21EAB85b044dDCafF1AccEAe1bcFABbB99CbD0cB ; < 3sfvlNKPMyXDXE3IN1OvD4Kb4glfnAw7lE9y1aqM55I5BD61rI5oQgTxabC5CvT0 > >										2
1809 //	        < 3 ; 4M ; MAY 2019 ; opt. ; - ; 0 ; 1,14145489844192 ; -1 ; -0,00025 ; 0,00025 ; 4,9 ; -7,8 ; -4,6 ; -7,6 ; 8,9 ; -9,8 ; 0,63 ; NABETHMA1962 ; E8c9cCccaBacFdccbc5cE54BFcA5BbBBCDBB7Fab6e20Fac16dE6e0Faca82d0e7 ; < 5sGtT7W5TwXnA4mAC9vvbs9Rg0Lez4S7A4X7DUl6hPO59MEbvD5KB0H3tC6Z8xZ7 > >										3
1810 //	        < 4 ; 6M ; JUL 2019 ; opt. ; - ; 0 ; 1,14236650981283 ; -1 ; -0,00025 ; 0,00025 ; 0 ; -4,4 ; -8,4 ; -1,7 ; 8 ; 0,1 ; -0,59 ; NABETHJU1995 ; Ea359E7B2baaD89e40524bD3FcA3E51524adCb9A6DBFBd50bDdac2c7Bc3977A7 ; < iJAEK75E0Ubv76Bx008GgS8gs59uxF6lb70YM5enfP1HE60O1wuin1NySixqS0D6 > >										4
1811 //	        < 5 ; 8M ; SEP 2019 ; opt. ; - ; 0 ; 1,14364357060859 ; -1 ; -0,00025 ; 0,00025 ; -9,4 ; -7,6 ; 2,7 ; -9,1 ; 8,5 ; 3,6 ; -0,41 ; NABETHSE1971 ; 4df5dEFbf3B55A34fcc9cEa4eBCE2eCcA4BdAf38cd90EeF03d26e1FAfeeEDEa9 ; < 52rKCozn97zA5MoQ7824Z2p1nLq4oX1rYupZ457g5yapQdjVw67lG33dp0bXY592 > >										5
1812 //	        < 6 ; 11M ; DEC 2019 ; opt. ; - ; 0 ; 1,14505850899257 ; -1 ; -0,00025 ; 0,00025 ; 4,5 ; 1,6 ; 1,9 ; -5,2 ; -8,3 ; -8,8 ; -0,39 ; NABETHDE1947 ; 6CECc2cD0Fa0CE9f9CF51AcDF9a8B4fAA0c3ED7EbA38B8c7b7fb23acD3cdE264 ; < Iddzjt1owEOidFRx17GlTeT2KuBF3E78lQO02q5NYB5011K14baC58w6L4K63Giv > >										6
1813 //	        < 7 ; 12M ; JAN 2020 ; opt. ; - ; 0 ; 1,1468088164366 ; -1 ; -0,00025 ; 0,00025 ; -0,5 ; -0,7 ; -1 ; -1,3 ; 0 ; -2,2 ; 0,75 ; NABETHJA2038 ; 2755a3b07Dbb6fe8BfDdCB5ceFC5acdADE0f114F37fEDC2F1b40C7eb1ddE38cc ; < c2nz3p653X412mg96Wk5zf8c1b40rruC2W8i35U3yz0r8jdHliVP4L1hwfcHlF2x > >										7
1814 //	        < 8 ; 14M ; MAR 2020 ; opt. ; - ; 0 ; 1,14870675405559 ; -1 ; -0,00025 ; 0,00025 ; -0,3 ; 3 ; 3,4 ; 1,3 ; 1,9 ; -4,9 ; -0,68 ; NABETHMA2031 ; 4d46f4adD81d1642EdcCa35CB87D1B9CC8c0B3B8Bd1AbB4efd5959e0bF83DF7d ; < c5Ph61U21D0Unfx8Mgf48C09GrD5J6ucSKPII2eGjzBY8CXq0J2cvTW85T1n2P16 > >										8
1815 //	        < 9 ; 16M ; MAY 2020 ; opt. ; - ; 0 ; 1,1508851783978 ; -1 ; -0,00025 ; 0,00025 ; -7,8 ; 2,3 ; -5 ; 8,1 ; 2,1 ; -5,6 ; -0,28 ; NABETHMA2082 ; cFcAbc9cd979fBEabCEE27bA1fb8e894eDbDdDFdcEdd05Eb3ABE7bb7e1ca0DfA ; < rqAyF2sWK93VZ2dKiS3xUVZe1wtvVm36YNBc7kqjdeyCNL62UrOEuziJhI1T0k0e > >										9
1816 //	        < 10 ; 18M ; JUL 2020 ; opt. ; - ; 0 ; 1,15322826521826 ; -1 ; -0,00025 ; 0,00025 ; -9,6 ; -1,5 ; -4,5 ; -4,8 ; 4,5 ; 9,8 ; -0,71 ; NABETHJU2056 ; 67Bd2dBed3494Ffcfad21A61bebBDADfDC7Fe6Fd939Dfcca06FAafEC83AFd394 ; < 2mw08Ah2d6acW03CMM80fxats5NCBScv9o7ZzL71Fsm2a2clHA4YWzgMp1vRA9rj > >										10
1817 //	        < 11 ; 20M ; SEP 2020 ; opt. ; - ; 0 ; 1,15581199030619 ; -1 ; -0,00025 ; 0,00025 ; 9,2 ; 4,6 ; 8,5 ; -5,7 ; -8 ; -1 ; -0,55 ; NABETHSE2052 ; f2b175edCBfb0eeAeEc83c6edF24bEdfe749A3de6C97bbcee4daAAcCbae6679F ; < WdeMg185lKS5ShGb383R1kZy22IWxkpa92dOc4dhLd6y8V8xfV3xR8F2Hvprvnzm > >										11
1818 //	        < 12 ; 23M ; DEC 2020 ; opt. ; - ; 0 ; 1,15859402976686 ; -1 ; -0,00025 ; 0,00025 ; -4,2 ; -5,9 ; 3,6 ; -0,4 ; 7 ; -8,9 ; -0,6 ; NABETHDE2069 ; 66745Bb6e3b4ffC19Ae6CfC2ed0bBbCABfeDa5A3beBaE5BA2C4AE1882D3ceD8F ; < 7Reve50cr2qveV4NoiOJ77qH0qUM7I93LOLahuda2bMojR1EkGJH5747P0S2CsSo > >										12
1819 //	        < 13 ; 24M ; JAN 2021 ; opt. ; - ; 0 ; 1,1616314175278 ; -1 ; -0,00025 ; 0,00025 ; 3,4 ; -4,4 ; 9,1 ; -6,1 ; 5,6 ; -3,9 ; -0,76 ; NABETHJA2183 ; fAddebC2a1Ced0C3F8Da9a4Fa004B4Bb557DACCD172DBDAe1a80cF32A91fBcd7 ; < 702OiSygi1357Goesgb7u8MxM3Xu5OHn4F8OU59x9zUJ233JQT210f5NVYg71m2j > >										13
1820 //	        < 14 ; 26M ; MAR 2021 ; opt. ; - ; 0 ; 1,16498188068828 ; -1 ; -0,00025 ; 0,00025 ; 6,2 ; 0 ; 7,8 ; -7,5 ; 7,5 ; 9,8 ; 0,13 ; NABETHMA2171 ; 7a4aAFAeBBD1878cdca13bE0cBbB9A0aa60AdCe69E46BeC9e8EB5E1B419C7fdC ; < 2q058Ox13HY87m44hvX70wC56Tc81290W3ZGft5H6Cvk2eT811pq9F6bc1650sGX > >										14
1821 //	        < 15 ; 28M ; MAY 2021 ; opt. ; - ; 0 ; 1,16865387556168 ; -1 ; -0,00025 ; 0,00025 ; -9 ; -7,2 ; -0,6 ; 6,4 ; -9,3 ; -9,3 ; -0,11 ; NABETHMA2177 ; bcB3CAB5daDC0D2625F15Ffd8cabcB8a2e30f0fEAB90C9c9FcCa2EaEac071a5F ; < Ypfv6XBO8xMP4KObkC0N9z35gtx6JqwX6ourv34488Kl692G7b0l8Y3VSzV3JNC5 > >										15
1822 //	        < 16 ; 30M ; JUL 2021 ; opt. ; - ; 0 ; 1,17258840763381 ; -1 ; -0,00025 ; 0,00025 ; 1,5 ; -4,9 ; 1,8 ; 1,8 ; -1,9 ; -5,5 ; 0,13 ; NABETHJU2164 ; 952ad6AAbf1edF6fA928Ddbd0cDBCf195Fb9cEBe2A54aBa43Ce2CFE7cB5bBa9e ; < dU18045tiz1MsG8aKC2465E42K0712o74LQMsJb4PmRvMQ60SzPx95D8Tkqxw03v > >										16
1823 //	        < 17 ; 32M ; SEP 2021 ; opt. ; - ; 0 ; 1,17664967976558 ; -1 ; -0,00025 ; 0,00025 ; -9,4 ; -8,1 ; 3 ; 5,3 ; -7 ; 8 ; 0,08 ; NABETHSE2199 ; d9Eb9fc1db15db9Adc136AEadBc3b7E9baDDE0EafbB39e8e8597ebb0EC534a2a ; < VKK07sCndFz66ql3b4237i24RG0V83DWsv1o568dQB49s5lLfH8wz1lLUxI1u68w > >										17
1824 //	        < 18 ; 35M ; DEC 2021 ; opt. ; - ; 0 ; 1,1810354564474 ; -1 ; -0,00025 ; 0,00025 ; 2,2 ; 5,3 ; 2,3 ; -8,3 ; -2,5 ; 9 ; 0,49 ; NABETHDE2192 ; 2B2eD30DFDBb88C3fA315dF0E7b4A1331Fa2AD71B0db03305fC32AF3532DbC72 ; < JMaHybwD6VNFJthj2EZ7ju8dvpXBPAtFB16Xwnn1xb8U6VrEV40zC629pTktMGaU > >										18
1825 //	        < 19 ; 36M ; JAN 2021 ; opt. ; - ; 0 ; 1,18570670987179 ; -1 ; -0,00025 ; 0,00025 ; 0,3 ; 1,3 ; -4,5 ; -6,8 ; 6,1 ; 9,1 ; 0,38 ; NABETHJA2155 ; bEeD0BC2a2cEc41bcbecA3BbaED46AF0bD59f4Ae4DcAC29C09DD5aaF06F8ab41 ; < Kn2yg13dkc8499i3Rw7ATZcv8mT8pqm0ZhtK84U05712huT8giNjc0I55nle9yT3 > >										19
1826 //	        < 20 ; 38M ; MAR 2021 ; opt. ; - ; 0 ; 1,19065601321761 ; -1 ; -0,00025 ; 0,00025 ; 3,8 ; 6,1 ; 7,7 ; 2,6 ; -9,4 ; 2,4 ; -0,31 ; NABETHMA2181 ; bbDe6bbbcFe2BdbEa3B8aFCfFE5fCfcDaCdDCCe1f9666bBfBadbd1A9DcdCfC35 ; < 6hVaA5f2Pr1ae1JFXLg5452c7smAXJEkz1CuBFQD7TIv30v3R2Tjj8wCp5H0q9M4 > >										20
1827 //	        < 21 ; 40M ; MAY 2021 ; opt. ; - ; 0 ; 1,19580452972815 ; -1 ; -0,00025 ; 0,00025 ; -9,2 ; -7 ; 8,8 ; 6,3 ; -2 ; 9,1 ; -0,8 ; NABETHMA2194 ; EAA8F32c1DCE3Acd3FBA0e8D30DE032fB5a06cD5dAEe0fc9D5E99be8deA0be6A ; < 7IyUUYo2M7k4gw95N3aZu1O596JbXC0I8w89NTbM9nHSJ2YBKMn1ps01UK73SudD > >										21
1828 //	        < 22 ; 42M ; JUL 2021 ; opt. ; - ; 0 ; 1,20122523958412 ; -1 ; -0,00025 ; 0,00025 ; 3 ; 3,6 ; -7,7 ; -2,5 ; 5,2 ; -5,8 ; -0,73 ; NABETHJU2120 ; AA015D8cc3ce74A16DB3FA9FEABb13733cDDFB6ebd1BeAAED3Fdb5cACFEfaa8c ; < UQ10B3C66OQXeZ8jJ4d6J7cnxy4DRJSNL9u6QOjvUFONOiecs483m4AU9qG2t5Pw > >										22
1829 //	        < 23 ; 44M ; SEP 2021 ; opt. ; - ; 0 ; 1,20697088818153 ; -1 ; -0,00025 ; 0,00025 ; -9,4 ; -8,5 ; -4,9 ; -3,1 ; -4,2 ; 3,7 ; 0,92 ; NABETHSE2119 ; 83B4D10b2C6d67A92fcFea4ABDdDBA5D3b5eDec77ebC409cdCaca6Ac28f4e04e ; < 3DXYCv5STs94OA97Z7RpsT2wYr1vtkm60uF5nYLJxtGbyqOWb09kK476USXg8TiX > >										23
1830 //	        < 24 ; 47M ; DEC 2021 ; opt. ; - ; 0 ; 1,21309173929822 ; -1 ; -0,00025 ; 0,00025 ; 0,6 ; -7,5 ; 1,4 ; -8,1 ; -9,6 ; -2,5 ; 0,68 ; NABETHDE2151 ; d3eCfccC5feFebaAcbf36c3BDc51ce8eEe6edcB9c6d9DdDA0F1f9dBb6FACBcd1 ; < td1DP04x0GskJ30Ur579Mw7k31pn4Og1um5611ANuQqiajeu98J5ZT351o0THHgc > >										24
1831 											
1832 //	  < CALLS ; 6M ; Strike ; Symbol ; Last ; T(-1) ; Change ; Volume ; BAS_1 ; BAS_2 ; o.i. @ eth_hex ; @ btc_882 >										
1833 											
1834 //	#DIV/0 !										1
1835 //	#DIV/0 !										2
1836 //	#DIV/0 !										3
1837 //	#DIV/0 !										4
1838 //	#DIV/0 !										5
1839 //	#DIV/0 !										6
1840 //	#DIV/0 !										7
1841 //	#DIV/0 !										8
1842 //	#DIV/0 !										9
1843 //	#DIV/0 !										10
1844 //	#DIV/0 !										11
1845 //	#DIV/0 !										12
1846 //	#DIV/0 !										13
1847 //	#DIV/0 !										14
1848 //	#DIV/0 !										15
1849 //	#DIV/0 !										16
1850 //	#DIV/0 !										17
1851 //	#DIV/0 !										18
1852 //	#DIV/0 !										19
1853 //	#DIV/0 !										20
1854 //	#DIV/0 !										21
1855 //											
1856 //	  < PUTS ; 6M ; Strike ; Symbol ; Last ; T(-1) ; Change ; Volume ; BAS_1 ; BAS_2 ; o.i. @ eth_hex ; @ btc_882 >										
1857 //											
1858 //	#DIV/0 !										1
1859 //	#DIV/0 !										2
1860 //	#DIV/0 !										3
1861 //	#DIV/0 !										4
1862 //	#DIV/0 !										5
1863 //	#DIV/0 !										6
1864 //	#DIV/0 !										7
1865 //	#DIV/0 !										8
1866 //	#DIV/0 !										9
1867 //	#DIV/0 !										10
1868 //	#DIV/0 !										11
1869 //	#DIV/0 !										12
1870 //	#DIV/0 !										13
1871 //	#DIV/0 !										14
1872 //	#DIV/0 !										15
1873 //	#DIV/0 !										16
1874 //	#DIV/0 !										17
1875 //	#DIV/0 !										18
1876 //	#DIV/0 !										19
1877 //	#DIV/0 !										20
1878 //	#DIV/0 !										21
1879 											
1880 											
1881 											
1882 											
1883 											
1884 //	NABETH										
1885 											
1886 //	  < # ; REF ; Month ; Optionchain ; Chart ; Last ; T(-1) ; Change ; BAS_1 ; BAS_2 ; Prior. Settle ; Open ; High ; Low ; Volume ; Hi / Lo ; Updated (s) ; Code ; @ eth_hex ; @ btc_882 >										
1887 											
1888 //	        < 0 ; T0 ; - ; - ; - ; 0 ; 1,14 ; -1 ; - ; - ; - ; - ; - ; - ; - ; - ; - ; - ; c46dFe0BcdDbC242FCcffEfe7adEDb875fceE771dcdC74Ff9Eb380bdD9efDe7A ; < QmUiLtY4zThGlnc1nJ2DGdYQw7r8240UhM78Efgvv0U79C13zp4hW216opNi3hb1 > >										0
1889 //	        < 1 ; 0M ; JAN 2019 ; opt. ; - ; 0 ; 1,14024520829845 ; -1 ; -0,00025 ; 0,00025 ; -0,1 ; -6,3 ; -6,3 ; 0,2 ; 8,4 ; 3,8 ; -0,62 ; NABETH45JA19 ; 79C41e7D8c24974e6dD7c8d87CBbd0Bc0AdE5abFB7EbBbfFFdDFDccB22bFba13 ; < yrv7q09CRZpc9y55DI8Ec2DNN33p0bB5IPDOQxkmxPAU83K5B9rI9hKpu6SO8A7j > >										1
1890 //	        < 2 ; 2M ; MAR 2019 ; opt. ; - ; 0 ; 1,14066622480045 ; -1 ; -0,00025 ; 0,00025 ; -0,1 ; 1 ; -1,1 ; 4 ; -1,4 ; -6,5 ; 0,76 ; NABETHMA1928 ; DcAcBD1EBEF83ae2BDacdAeA21EAB85b044dDCafF1AccEAe1bcFABbB99CbD0cB ; < 3sfvlNKPMyXDXE3IN1OvD4Kb4glfnAw7lE9y1aqM55I5BD61rI5oQgTxabC5CvT0 > >										2
1891 //	        < 3 ; 4M ; MAY 2019 ; opt. ; - ; 0 ; 1,14145489844192 ; -1 ; -0,00025 ; 0,00025 ; 4,9 ; -7,8 ; -4,6 ; -7,6 ; 8,9 ; -9,8 ; 0,63 ; NABETHMA1962 ; E8c9cCccaBacFdccbc5cE54BFcA5BbBBCDBB7Fab6e20Fac16dE6e0Faca82d0e7 ; < 5sGtT7W5TwXnA4mAC9vvbs9Rg0Lez4S7A4X7DUl6hPO59MEbvD5KB0H3tC6Z8xZ7 > >										3
1892 //	        < 4 ; 6M ; JUL 2019 ; opt. ; - ; 0 ; 1,14236650981283 ; -1 ; -0,00025 ; 0,00025 ; 0 ; -4,4 ; -8,4 ; -1,7 ; 8 ; 0,1 ; -0,59 ; NABETHJU1995 ; Ea359E7B2baaD89e40524bD3FcA3E51524adCb9A6DBFBd50bDdac2c7Bc3977A7 ; < iJAEK75E0Ubv76Bx008GgS8gs59uxF6lb70YM5enfP1HE60O1wuin1NySixqS0D6 > >										4
1893 //	        < 5 ; 8M ; SEP 2019 ; opt. ; - ; 0 ; 1,14364357060859 ; -1 ; -0,00025 ; 0,00025 ; -9,4 ; -7,6 ; 2,7 ; -9,1 ; 8,5 ; 3,6 ; -0,41 ; NABETHSE1971 ; 4df5dEFbf3B55A34fcc9cEa4eBCE2eCcA4BdAf38cd90EeF03d26e1FAfeeEDEa9 ; < 52rKCozn97zA5MoQ7824Z2p1nLq4oX1rYupZ457g5yapQdjVw67lG33dp0bXY592 > >										5
1894 //	        < 6 ; 11M ; DEC 2019 ; opt. ; - ; 0 ; 1,14505850899257 ; -1 ; -0,00025 ; 0,00025 ; 4,5 ; 1,6 ; 1,9 ; -5,2 ; -8,3 ; -8,8 ; -0,39 ; NABETHDE1947 ; 6CECc2cD0Fa0CE9f9CF51AcDF9a8B4fAA0c3ED7EbA38B8c7b7fb23acD3cdE264 ; < Iddzjt1owEOidFRx17GlTeT2KuBF3E78lQO02q5NYB5011K14baC58w6L4K63Giv > >										6
1895 //	        < 7 ; 12M ; JAN 2020 ; opt. ; - ; 0 ; 1,1468088164366 ; -1 ; -0,00025 ; 0,00025 ; -0,5 ; -0,7 ; -1 ; -1,3 ; 0 ; -2,2 ; 0,75 ; NABETHJA2038 ; 2755a3b07Dbb6fe8BfDdCB5ceFC5acdADE0f114F37fEDC2F1b40C7eb1ddE38cc ; < c2nz3p653X412mg96Wk5zf8c1b40rruC2W8i35U3yz0r8jdHliVP4L1hwfcHlF2x > >										7
1896 //	        < 8 ; 14M ; MAR 2020 ; opt. ; - ; 0 ; 1,14870675405559 ; -1 ; -0,00025 ; 0,00025 ; -0,3 ; 3 ; 3,4 ; 1,3 ; 1,9 ; -4,9 ; -0,68 ; NABETHMA2031 ; 4d46f4adD81d1642EdcCa35CB87D1B9CC8c0B3B8Bd1AbB4efd5959e0bF83DF7d ; < c5Ph61U21D0Unfx8Mgf48C09GrD5J6ucSKPII2eGjzBY8CXq0J2cvTW85T1n2P16 > >										8
1897 //	        < 9 ; 16M ; MAY 2020 ; opt. ; - ; 0 ; 1,1508851783978 ; -1 ; -0,00025 ; 0,00025 ; -7,8 ; 2,3 ; -5 ; 8,1 ; 2,1 ; -5,6 ; -0,28 ; NABETHMA2082 ; cFcAbc9cd979fBEabCEE27bA1fb8e894eDbDdDFdcEdd05Eb3ABE7bb7e1ca0DfA ; < rqAyF2sWK93VZ2dKiS3xUVZe1wtvVm36YNBc7kqjdeyCNL62UrOEuziJhI1T0k0e > >										9
1898 //	        < 10 ; 18M ; JUL 2020 ; opt. ; - ; 0 ; 1,15322826521826 ; -1 ; -0,00025 ; 0,00025 ; -9,6 ; -1,5 ; -4,5 ; -4,8 ; 4,5 ; 9,8 ; -0,71 ; NABETHJU2056 ; 67Bd2dBed3494Ffcfad21A61bebBDADfDC7Fe6Fd939Dfcca06FAafEC83AFd394 ; < 2mw08Ah2d6acW03CMM80fxats5NCBScv9o7ZzL71Fsm2a2clHA4YWzgMp1vRA9rj > >										10
1899 //	        < 11 ; 20M ; SEP 2020 ; opt. ; - ; 0 ; 1,15581199030619 ; -1 ; -0,00025 ; 0,00025 ; 9,2 ; 4,6 ; 8,5 ; -5,7 ; -8 ; -1 ; -0,55 ; NABETHSE2052 ; f2b175edCBfb0eeAeEc83c6edF24bEdfe749A3de6C97bbcee4daAAcCbae6679F ; < WdeMg185lKS5ShGb383R1kZy22IWxkpa92dOc4dhLd6y8V8xfV3xR8F2Hvprvnzm > >										11
1900 //	        < 12 ; 23M ; DEC 2020 ; opt. ; - ; 0 ; 1,15859402976686 ; -1 ; -0,00025 ; 0,00025 ; -4,2 ; -5,9 ; 3,6 ; -0,4 ; 7 ; -8,9 ; -0,6 ; NABETHDE2069 ; 66745Bb6e3b4ffC19Ae6CfC2ed0bBbCABfeDa5A3beBaE5BA2C4AE1882D3ceD8F ; < 7Reve50cr2qveV4NoiOJ77qH0qUM7I93LOLahuda2bMojR1EkGJH5747P0S2CsSo > >										12
1901 //	        < 13 ; 24M ; JAN 2021 ; opt. ; - ; 0 ; 1,1616314175278 ; -1 ; -0,00025 ; 0,00025 ; 3,4 ; -4,4 ; 9,1 ; -6,1 ; 5,6 ; -3,9 ; -0,76 ; NABETHJA2183 ; fAddebC2a1Ced0C3F8Da9a4Fa004B4Bb557DACCD172DBDAe1a80cF32A91fBcd7 ; < 702OiSygi1357Goesgb7u8MxM3Xu5OHn4F8OU59x9zUJ233JQT210f5NVYg71m2j > >										13
1902 //	        < 14 ; 26M ; MAR 2021 ; opt. ; - ; 0 ; 1,16498188068828 ; -1 ; -0,00025 ; 0,00025 ; 6,2 ; 0 ; 7,8 ; -7,5 ; 7,5 ; 9,8 ; 0,13 ; NABETHMA2171 ; 7a4aAFAeBBD1878cdca13bE0cBbB9A0aa60AdCe69E46BeC9e8EB5E1B419C7fdC ; < 2q058Ox13HY87m44hvX70wC56Tc81290W3ZGft5H6Cvk2eT811pq9F6bc1650sGX > >										14
1903 //	        < 15 ; 28M ; MAY 2021 ; opt. ; - ; 0 ; 1,16865387556168 ; -1 ; -0,00025 ; 0,00025 ; -9 ; -7,2 ; -0,6 ; 6,4 ; -9,3 ; -9,3 ; -0,11 ; NABETHMA2177 ; bcB3CAB5daDC0D2625F15Ffd8cabcB8a2e30f0fEAB90C9c9FcCa2EaEac071a5F ; < Ypfv6XBO8xMP4KObkC0N9z35gtx6JqwX6ourv34488Kl692G7b0l8Y3VSzV3JNC5 > >										15
1904 //	        < 16 ; 30M ; JUL 2021 ; opt. ; - ; 0 ; 1,17258840763381 ; -1 ; -0,00025 ; 0,00025 ; 1,5 ; -4,9 ; 1,8 ; 1,8 ; -1,9 ; -5,5 ; 0,13 ; NABETHJU2164 ; 952ad6AAbf1edF6fA928Ddbd0cDBCf195Fb9cEBe2A54aBa43Ce2CFE7cB5bBa9e ; < dU18045tiz1MsG8aKC2465E42K0712o74LQMsJb4PmRvMQ60SzPx95D8Tkqxw03v > >										16
1905 //	        < 17 ; 32M ; SEP 2021 ; opt. ; - ; 0 ; 1,17664967976558 ; -1 ; -0,00025 ; 0,00025 ; -9,4 ; -8,1 ; 3 ; 5,3 ; -7 ; 8 ; 0,08 ; NABETHSE2199 ; d9Eb9fc1db15db9Adc136AEadBc3b7E9baDDE0EafbB39e8e8597ebb0EC534a2a ; < VKK07sCndFz66ql3b4237i24RG0V83DWsv1o568dQB49s5lLfH8wz1lLUxI1u68w > >										17
1906 //	        < 18 ; 35M ; DEC 2021 ; opt. ; - ; 0 ; 1,1810354564474 ; -1 ; -0,00025 ; 0,00025 ; 2,2 ; 5,3 ; 2,3 ; -8,3 ; -2,5 ; 9 ; 0,49 ; NABETHDE2192 ; 2B2eD30DFDBb88C3fA315dF0E7b4A1331Fa2AD71B0db03305fC32AF3532DbC72 ; < JMaHybwD6VNFJthj2EZ7ju8dvpXBPAtFB16Xwnn1xb8U6VrEV40zC629pTktMGaU > >										18
1907 //	        < 19 ; 36M ; JAN 2021 ; opt. ; - ; 0 ; 1,18570670987179 ; -1 ; -0,00025 ; 0,00025 ; 0,3 ; 1,3 ; -4,5 ; -6,8 ; 6,1 ; 9,1 ; 0,38 ; NABETHJA2155 ; bEeD0BC2a2cEc41bcbecA3BbaED46AF0bD59f4Ae4DcAC29C09DD5aaF06F8ab41 ; < Kn2yg13dkc8499i3Rw7ATZcv8mT8pqm0ZhtK84U05712huT8giNjc0I55nle9yT3 > >										19
1908 //	        < 20 ; 38M ; MAR 2021 ; opt. ; - ; 0 ; 1,19065601321761 ; -1 ; -0,00025 ; 0,00025 ; 3,8 ; 6,1 ; 7,7 ; 2,6 ; -9,4 ; 2,4 ; -0,31 ; NABETHMA2181 ; bbDe6bbbcFe2BdbEa3B8aFCfFE5fCfcDaCdDCCe1f9666bBfBadbd1A9DcdCfC35 ; < 6hVaA5f2Pr1ae1JFXLg5452c7smAXJEkz1CuBFQD7TIv30v3R2Tjj8wCp5H0q9M4 > >										20
1909 //	        < 21 ; 40M ; MAY 2021 ; opt. ; - ; 0 ; 1,19580452972815 ; -1 ; -0,00025 ; 0,00025 ; -9,2 ; -7 ; 8,8 ; 6,3 ; -2 ; 9,1 ; -0,8 ; NABETHMA2194 ; EAA8F32c1DCE3Acd3FBA0e8D30DE032fB5a06cD5dAEe0fc9D5E99be8deA0be6A ; < 7IyUUYo2M7k4gw95N3aZu1O596JbXC0I8w89NTbM9nHSJ2YBKMn1ps01UK73SudD > >										21
1910 //	        < 22 ; 42M ; JUL 2021 ; opt. ; - ; 0 ; 1,20122523958412 ; -1 ; -0,00025 ; 0,00025 ; 3 ; 3,6 ; -7,7 ; -2,5 ; 5,2 ; -5,8 ; -0,73 ; NABETHJU2120 ; AA015D8cc3ce74A16DB3FA9FEABb13733cDDFB6ebd1BeAAED3Fdb5cACFEfaa8c ; < UQ10B3C66OQXeZ8jJ4d6J7cnxy4DRJSNL9u6QOjvUFONOiecs483m4AU9qG2t5Pw > >										22
1911 //	        < 23 ; 44M ; SEP 2021 ; opt. ; - ; 0 ; 1,20697088818153 ; -1 ; -0,00025 ; 0,00025 ; -9,4 ; -8,5 ; -4,9 ; -3,1 ; -4,2 ; 3,7 ; 0,92 ; NABETHSE2119 ; 83B4D10b2C6d67A92fcFea4ABDdDBA5D3b5eDec77ebC409cdCaca6Ac28f4e04e ; < 3DXYCv5STs94OA97Z7RpsT2wYr1vtkm60uF5nYLJxtGbyqOWb09kK476USXg8TiX > >										23
1912 //	        < 24 ; 47M ; DEC 2021 ; opt. ; - ; 0 ; 1,21309173929822 ; -1 ; -0,00025 ; 0,00025 ; 0,6 ; -7,5 ; 1,4 ; -8,1 ; -9,6 ; -2,5 ; 0,68 ; NABETHDE2151 ; d3eCfccC5feFebaAcbf36c3BDc51ce8eEe6edcB9c6d9DdDA0F1f9dBb6FACBcd1 ; < td1DP04x0GskJ30Ur579Mw7k31pn4Og1um5611ANuQqiajeu98J5ZT351o0THHgc > >										24
1913 											
1914 //	  < CALLS ; 12M ; Strike ; Symbol ; Last ; T(-1) ; Change ; Volume ; BAS_1 ; BAS_2 ; o.i. @ eth_hex ; @ btc_882 >										
1915 											
1916 //	#DIV/0 !										1
1917 //	#DIV/0 !										2
1918 //	#DIV/0 !										3
1919 //	#DIV/0 !										4
1920 //	#DIV/0 !										5
1921 //	#DIV/0 !										6
1922 //	#DIV/0 !										7
1923 //	#DIV/0 !										8
1924 //	#DIV/0 !										9
1925 //	#DIV/0 !										10
1926 //	#DIV/0 !										11
1927 //	#DIV/0 !										12
1928 //	#DIV/0 !										13
1929 //	#DIV/0 !										14
1930 //	#DIV/0 !										15
1931 //	#DIV/0 !										16
1932 //	#DIV/0 !										17
1933 //	#DIV/0 !										18
1934 //	#DIV/0 !										19
1935 //	#DIV/0 !										20
1936 //	#DIV/0 !										21
1937 //											
1938 //	  < PUTS ; 12M ; Strike ; Symbol ; Last ; T(-1) ; Change ; Volume ; BAS_1 ; BAS_2 ; o.i. @ eth_hex ; @ btc_882 >										
1939 //											
1940 //	#DIV/0 !										1
1941 //	#DIV/0 !										2
1942 //	#DIV/0 !										3
1943 //	#DIV/0 !										4
1944 //	#DIV/0 !										5
1945 //	#DIV/0 !										6
1946 //	#DIV/0 !										7
1947 //	#DIV/0 !										8
1948 //	#DIV/0 !										9
1949 //	#DIV/0 !										10
1950 //	#DIV/0 !										11
1951 //	#DIV/0 !										12
1952 //	#DIV/0 !										13
1953 //	#DIV/0 !										14
1954 //	#DIV/0 !										15
1955 //	#DIV/0 !										16
1956 //	#DIV/0 !										17
1957 //	#DIV/0 !										18
1958 //	#DIV/0 !										19
1959 //	#DIV/0 !										20
1960 //	#DIV/0 !										21
1961 											
1962 											
1963 											
1964 											
1965 											
1966 //	NABETH										
1967 											
1968 //	  < # ; REF ; Month ; Optionchain ; Chart ; Last ; T(-1) ; Change ; BAS_1 ; BAS_2 ; Prior. Settle ; Open ; High ; Low ; Volume ; Hi / Lo ; Updated (s) ; Code ; @ eth_hex ; @ btc_882 >										
1969 											
1970 //	        < 0 ; T0 ; - ; - ; - ; 0 ; 1,14 ; -1 ; - ; - ; - ; - ; - ; - ; - ; - ; - ; - ; c46dFe0BcdDbC242FCcffEfe7adEDb875fceE771dcdC74Ff9Eb380bdD9efDe7A ; < QmUiLtY4zThGlnc1nJ2DGdYQw7r8240UhM78Efgvv0U79C13zp4hW216opNi3hb1 > >										0
1971 //	        < 1 ; 0M ; JAN 2019 ; opt. ; - ; 0 ; 1,14024520829845 ; -1 ; -0,00025 ; 0,00025 ; -0,1 ; -6,3 ; -6,3 ; 0,2 ; 8,4 ; 3,8 ; -0,62 ; NABETH45JA19 ; 79C41e7D8c24974e6dD7c8d87CBbd0Bc0AdE5abFB7EbBbfFFdDFDccB22bFba13 ; < yrv7q09CRZpc9y55DI8Ec2DNN33p0bB5IPDOQxkmxPAU83K5B9rI9hKpu6SO8A7j > >										1
1972 //	        < 2 ; 2M ; MAR 2019 ; opt. ; - ; 0 ; 1,14066622480045 ; -1 ; -0,00025 ; 0,00025 ; -0,1 ; 1 ; -1,1 ; 4 ; -1,4 ; -6,5 ; 0,76 ; NABETHMA1928 ; DcAcBD1EBEF83ae2BDacdAeA21EAB85b044dDCafF1AccEAe1bcFABbB99CbD0cB ; < 3sfvlNKPMyXDXE3IN1OvD4Kb4glfnAw7lE9y1aqM55I5BD61rI5oQgTxabC5CvT0 > >										2
1973 //	        < 3 ; 4M ; MAY 2019 ; opt. ; - ; 0 ; 1,14145489844192 ; -1 ; -0,00025 ; 0,00025 ; 4,9 ; -7,8 ; -4,6 ; -7,6 ; 8,9 ; -9,8 ; 0,63 ; NABETHMA1962 ; E8c9cCccaBacFdccbc5cE54BFcA5BbBBCDBB7Fab6e20Fac16dE6e0Faca82d0e7 ; < 5sGtT7W5TwXnA4mAC9vvbs9Rg0Lez4S7A4X7DUl6hPO59MEbvD5KB0H3tC6Z8xZ7 > >										3
1974 //	        < 4 ; 6M ; JUL 2019 ; opt. ; - ; 0 ; 1,14236650981283 ; -1 ; -0,00025 ; 0,00025 ; 0 ; -4,4 ; -8,4 ; -1,7 ; 8 ; 0,1 ; -0,59 ; NABETHJU1995 ; Ea359E7B2baaD89e40524bD3FcA3E51524adCb9A6DBFBd50bDdac2c7Bc3977A7 ; < iJAEK75E0Ubv76Bx008GgS8gs59uxF6lb70YM5enfP1HE60O1wuin1NySixqS0D6 > >										4
1975 //	        < 5 ; 8M ; SEP 2019 ; opt. ; - ; 0 ; 1,14364357060859 ; -1 ; -0,00025 ; 0,00025 ; -9,4 ; -7,6 ; 2,7 ; -9,1 ; 8,5 ; 3,6 ; -0,41 ; NABETHSE1971 ; 4df5dEFbf3B55A34fcc9cEa4eBCE2eCcA4BdAf38cd90EeF03d26e1FAfeeEDEa9 ; < 52rKCozn97zA5MoQ7824Z2p1nLq4oX1rYupZ457g5yapQdjVw67lG33dp0bXY592 > >										5
1976 //	        < 6 ; 11M ; DEC 2019 ; opt. ; - ; 0 ; 1,14505850899257 ; -1 ; -0,00025 ; 0,00025 ; 4,5 ; 1,6 ; 1,9 ; -5,2 ; -8,3 ; -8,8 ; -0,39 ; NABETHDE1947 ; 6CECc2cD0Fa0CE9f9CF51AcDF9a8B4fAA0c3ED7EbA38B8c7b7fb23acD3cdE264 ; < Iddzjt1owEOidFRx17GlTeT2KuBF3E78lQO02q5NYB5011K14baC58w6L4K63Giv > >										6
1977 //	        < 7 ; 12M ; JAN 2020 ; opt. ; - ; 0 ; 1,1468088164366 ; -1 ; -0,00025 ; 0,00025 ; -0,5 ; -0,7 ; -1 ; -1,3 ; 0 ; -2,2 ; 0,75 ; NABETHJA2038 ; 2755a3b07Dbb6fe8BfDdCB5ceFC5acdADE0f114F37fEDC2F1b40C7eb1ddE38cc ; < c2nz3p653X412mg96Wk5zf8c1b40rruC2W8i35U3yz0r8jdHliVP4L1hwfcHlF2x > >										7
1978 //	        < 8 ; 14M ; MAR 2020 ; opt. ; - ; 0 ; 1,14870675405559 ; -1 ; -0,00025 ; 0,00025 ; -0,3 ; 3 ; 3,4 ; 1,3 ; 1,9 ; -4,9 ; -0,68 ; NABETHMA2031 ; 4d46f4adD81d1642EdcCa35CB87D1B9CC8c0B3B8Bd1AbB4efd5959e0bF83DF7d ; < c5Ph61U21D0Unfx8Mgf48C09GrD5J6ucSKPII2eGjzBY8CXq0J2cvTW85T1n2P16 > >										8
1979 //	        < 9 ; 16M ; MAY 2020 ; opt. ; - ; 0 ; 1,1508851783978 ; -1 ; -0,00025 ; 0,00025 ; -7,8 ; 2,3 ; -5 ; 8,1 ; 2,1 ; -5,6 ; -0,28 ; NABETHMA2082 ; cFcAbc9cd979fBEabCEE27bA1fb8e894eDbDdDFdcEdd05Eb3ABE7bb7e1ca0DfA ; < rqAyF2sWK93VZ2dKiS3xUVZe1wtvVm36YNBc7kqjdeyCNL62UrOEuziJhI1T0k0e > >										9
1980 //	        < 10 ; 18M ; JUL 2020 ; opt. ; - ; 0 ; 1,15322826521826 ; -1 ; -0,00025 ; 0,00025 ; -9,6 ; -1,5 ; -4,5 ; -4,8 ; 4,5 ; 9,8 ; -0,71 ; NABETHJU2056 ; 67Bd2dBed3494Ffcfad21A61bebBDADfDC7Fe6Fd939Dfcca06FAafEC83AFd394 ; < 2mw08Ah2d6acW03CMM80fxats5NCBScv9o7ZzL71Fsm2a2clHA4YWzgMp1vRA9rj > >										10
1981 //	        < 11 ; 20M ; SEP 2020 ; opt. ; - ; 0 ; 1,15581199030619 ; -1 ; -0,00025 ; 0,00025 ; 9,2 ; 4,6 ; 8,5 ; -5,7 ; -8 ; -1 ; -0,55 ; NABETHSE2052 ; f2b175edCBfb0eeAeEc83c6edF24bEdfe749A3de6C97bbcee4daAAcCbae6679F ; < WdeMg185lKS5ShGb383R1kZy22IWxkpa92dOc4dhLd6y8V8xfV3xR8F2Hvprvnzm > >										11
1982 //	        < 12 ; 23M ; DEC 2020 ; opt. ; - ; 0 ; 1,15859402976686 ; -1 ; -0,00025 ; 0,00025 ; -4,2 ; -5,9 ; 3,6 ; -0,4 ; 7 ; -8,9 ; -0,6 ; NABETHDE2069 ; 66745Bb6e3b4ffC19Ae6CfC2ed0bBbCABfeDa5A3beBaE5BA2C4AE1882D3ceD8F ; < 7Reve50cr2qveV4NoiOJ77qH0qUM7I93LOLahuda2bMojR1EkGJH5747P0S2CsSo > >										12
1983 //	        < 13 ; 24M ; JAN 2021 ; opt. ; - ; 0 ; 1,1616314175278 ; -1 ; -0,00025 ; 0,00025 ; 3,4 ; -4,4 ; 9,1 ; -6,1 ; 5,6 ; -3,9 ; -0,76 ; NABETHJA2183 ; fAddebC2a1Ced0C3F8Da9a4Fa004B4Bb557DACCD172DBDAe1a80cF32A91fBcd7 ; < 702OiSygi1357Goesgb7u8MxM3Xu5OHn4F8OU59x9zUJ233JQT210f5NVYg71m2j > >										13
1984 //	        < 14 ; 26M ; MAR 2021 ; opt. ; - ; 0 ; 1,16498188068828 ; -1 ; -0,00025 ; 0,00025 ; 6,2 ; 0 ; 7,8 ; -7,5 ; 7,5 ; 9,8 ; 0,13 ; NABETHMA2171 ; 7a4aAFAeBBD1878cdca13bE0cBbB9A0aa60AdCe69E46BeC9e8EB5E1B419C7fdC ; < 2q058Ox13HY87m44hvX70wC56Tc81290W3ZGft5H6Cvk2eT811pq9F6bc1650sGX > >										14
1985 //	        < 15 ; 28M ; MAY 2021 ; opt. ; - ; 0 ; 1,16865387556168 ; -1 ; -0,00025 ; 0,00025 ; -9 ; -7,2 ; -0,6 ; 6,4 ; -9,3 ; -9,3 ; -0,11 ; NABETHMA2177 ; bcB3CAB5daDC0D2625F15Ffd8cabcB8a2e30f0fEAB90C9c9FcCa2EaEac071a5F ; < Ypfv6XBO8xMP4KObkC0N9z35gtx6JqwX6ourv34488Kl692G7b0l8Y3VSzV3JNC5 > >										15
1986 //	        < 16 ; 30M ; JUL 2021 ; opt. ; - ; 0 ; 1,17258840763381 ; -1 ; -0,00025 ; 0,00025 ; 1,5 ; -4,9 ; 1,8 ; 1,8 ; -1,9 ; -5,5 ; 0,13 ; NABETHJU2164 ; 952ad6AAbf1edF6fA928Ddbd0cDBCf195Fb9cEBe2A54aBa43Ce2CFE7cB5bBa9e ; < dU18045tiz1MsG8aKC2465E42K0712o74LQMsJb4PmRvMQ60SzPx95D8Tkqxw03v > >										16
1987 //	        < 17 ; 32M ; SEP 2021 ; opt. ; - ; 0 ; 1,17664967976558 ; -1 ; -0,00025 ; 0,00025 ; -9,4 ; -8,1 ; 3 ; 5,3 ; -7 ; 8 ; 0,08 ; NABETHSE2199 ; d9Eb9fc1db15db9Adc136AEadBc3b7E9baDDE0EafbB39e8e8597ebb0EC534a2a ; < VKK07sCndFz66ql3b4237i24RG0V83DWsv1o568dQB49s5lLfH8wz1lLUxI1u68w > >										17
1988 //	        < 18 ; 35M ; DEC 2021 ; opt. ; - ; 0 ; 1,1810354564474 ; -1 ; -0,00025 ; 0,00025 ; 2,2 ; 5,3 ; 2,3 ; -8,3 ; -2,5 ; 9 ; 0,49 ; NABETHDE2192 ; 2B2eD30DFDBb88C3fA315dF0E7b4A1331Fa2AD71B0db03305fC32AF3532DbC72 ; < JMaHybwD6VNFJthj2EZ7ju8dvpXBPAtFB16Xwnn1xb8U6VrEV40zC629pTktMGaU > >										18
1989 //	        < 19 ; 36M ; JAN 2021 ; opt. ; - ; 0 ; 1,18570670987179 ; -1 ; -0,00025 ; 0,00025 ; 0,3 ; 1,3 ; -4,5 ; -6,8 ; 6,1 ; 9,1 ; 0,38 ; NABETHJA2155 ; bEeD0BC2a2cEc41bcbecA3BbaED46AF0bD59f4Ae4DcAC29C09DD5aaF06F8ab41 ; < Kn2yg13dkc8499i3Rw7ATZcv8mT8pqm0ZhtK84U05712huT8giNjc0I55nle9yT3 > >										19
1990 //	        < 20 ; 38M ; MAR 2021 ; opt. ; - ; 0 ; 1,19065601321761 ; -1 ; -0,00025 ; 0,00025 ; 3,8 ; 6,1 ; 7,7 ; 2,6 ; -9,4 ; 2,4 ; -0,31 ; NABETHMA2181 ; bbDe6bbbcFe2BdbEa3B8aFCfFE5fCfcDaCdDCCe1f9666bBfBadbd1A9DcdCfC35 ; < 6hVaA5f2Pr1ae1JFXLg5452c7smAXJEkz1CuBFQD7TIv30v3R2Tjj8wCp5H0q9M4 > >										20
1991 //	        < 21 ; 40M ; MAY 2021 ; opt. ; - ; 0 ; 1,19580452972815 ; -1 ; -0,00025 ; 0,00025 ; -9,2 ; -7 ; 8,8 ; 6,3 ; -2 ; 9,1 ; -0,8 ; NABETHMA2194 ; EAA8F32c1DCE3Acd3FBA0e8D30DE032fB5a06cD5dAEe0fc9D5E99be8deA0be6A ; < 7IyUUYo2M7k4gw95N3aZu1O596JbXC0I8w89NTbM9nHSJ2YBKMn1ps01UK73SudD > >										21
1992 //	        < 22 ; 42M ; JUL 2021 ; opt. ; - ; 0 ; 1,20122523958412 ; -1 ; -0,00025 ; 0,00025 ; 3 ; 3,6 ; -7,7 ; -2,5 ; 5,2 ; -5,8 ; -0,73 ; NABETHJU2120 ; AA015D8cc3ce74A16DB3FA9FEABb13733cDDFB6ebd1BeAAED3Fdb5cACFEfaa8c ; < UQ10B3C66OQXeZ8jJ4d6J7cnxy4DRJSNL9u6QOjvUFONOiecs483m4AU9qG2t5Pw > >										22
1993 //	        < 23 ; 44M ; SEP 2021 ; opt. ; - ; 0 ; 1,20697088818153 ; -1 ; -0,00025 ; 0,00025 ; -9,4 ; -8,5 ; -4,9 ; -3,1 ; -4,2 ; 3,7 ; 0,92 ; NABETHSE2119 ; 83B4D10b2C6d67A92fcFea4ABDdDBA5D3b5eDec77ebC409cdCaca6Ac28f4e04e ; < 3DXYCv5STs94OA97Z7RpsT2wYr1vtkm60uF5nYLJxtGbyqOWb09kK476USXg8TiX > >										23
1994 //	        < 24 ; 47M ; DEC 2021 ; opt. ; - ; 0 ; 1,21309173929822 ; -1 ; -0,00025 ; 0,00025 ; 0,6 ; -7,5 ; 1,4 ; -8,1 ; -9,6 ; -2,5 ; 0,68 ; NABETHDE2151 ; d3eCfccC5feFebaAcbf36c3BDc51ce8eEe6edcB9c6d9DdDA0F1f9dBb6FACBcd1 ; < td1DP04x0GskJ30Ur579Mw7k31pn4Og1um5611ANuQqiajeu98J5ZT351o0THHgc > >										24
1995 											
1996 //	  < CALLS ; 24M ; Strike ; Symbol ; Last ; T(-1) ; Change ; Volume ; BAS_1 ; BAS_2 ; o.i. @ eth_hex ; @ btc_882 >										
1997 											
1998 //	#DIV/0 !										1
1999 //	#DIV/0 !										2
2000 //	#DIV/0 !										3
2001 //	#DIV/0 !										4
2002 //	#DIV/0 !										5
2003 //	#DIV/0 !										6
2004 //	#DIV/0 !										7
2005 //	#DIV/0 !										8
2006 //	#DIV/0 !										9
2007 //	#DIV/0 !										10
2008 //	#DIV/0 !										11
2009 //	#DIV/0 !										12
2010 //	#DIV/0 !										13
2011 //	#DIV/0 !										14
2012 //	#DIV/0 !										15
2013 //	#DIV/0 !										16
2014 //	#DIV/0 !										17
2015 //	#DIV/0 !										18
2016 //	#DIV/0 !										19
2017 //	#DIV/0 !										20
2018 //	#DIV/0 !										21
2019 //											
2020 //	  < PUTS ; 24M ; Strike ; Symbol ; Last ; T(-1) ; Change ; Volume ; BAS_1 ; BAS_2 ; o.i. @ eth_hex ; @ btc_882 >										
2021 //											
2022 //	#DIV/0 !										1
2023 //	#DIV/0 !										2
2024 //	#DIV/0 !										3
2025 //	#DIV/0 !										4
2026 //	#DIV/0 !										5
2027 //	#DIV/0 !										6
2028 //	#DIV/0 !										7
2029 //	#DIV/0 !										8
2030 //	#DIV/0 !										9
2031 //	#DIV/0 !										10
2032 //	#DIV/0 !										11
2033 //	#DIV/0 !										12
2034 //	#DIV/0 !										13
2035 //	#DIV/0 !										14
2036 //	#DIV/0 !										15
2037 //	#DIV/0 !										16
2038 //	#DIV/0 !										17
2039 //	#DIV/0 !										18
2040 //	#DIV/0 !										19
2041 //	#DIV/0 !										20
2042 //	#DIV/0 !										21
2043 											
2044 											
2045 											
2046 											
2047 											
2048 //	NABETH										
2049 											
2050 //	  < # ; REF ; Month ; Optionchain ; Chart ; Last ; T(-1) ; Change ; BAS_1 ; BAS_2 ; Prior. Settle ; Open ; High ; Low ; Volume ; Hi / Lo ; Updated (s) ; Code ; @ eth_hex ; @ btc_882 >										
2051 											
2052 //	        < 0 ; T0 ; - ; - ; - ; 0 ; 1,14 ; -1 ; - ; - ; - ; - ; - ; - ; - ; - ; - ; - ; c46dFe0BcdDbC242FCcffEfe7adEDb875fceE771dcdC74Ff9Eb380bdD9efDe7A ; < QmUiLtY4zThGlnc1nJ2DGdYQw7r8240UhM78Efgvv0U79C13zp4hW216opNi3hb1 > >										0
2053 //	        < 1 ; 0M ; JAN 2019 ; opt. ; - ; 0 ; 1,14024520829845 ; -1 ; -0,00025 ; 0,00025 ; -0,1 ; -6,3 ; -6,3 ; 0,2 ; 8,4 ; 3,8 ; -0,62 ; NABETH45JA19 ; 79C41e7D8c24974e6dD7c8d87CBbd0Bc0AdE5abFB7EbBbfFFdDFDccB22bFba13 ; < yrv7q09CRZpc9y55DI8Ec2DNN33p0bB5IPDOQxkmxPAU83K5B9rI9hKpu6SO8A7j > >										1
2054 //	        < 2 ; 2M ; MAR 2019 ; opt. ; - ; 0 ; 1,14066622480045 ; -1 ; -0,00025 ; 0,00025 ; -0,1 ; 1 ; -1,1 ; 4 ; -1,4 ; -6,5 ; 0,76 ; NABETHMA1928 ; DcAcBD1EBEF83ae2BDacdAeA21EAB85b044dDCafF1AccEAe1bcFABbB99CbD0cB ; < 3sfvlNKPMyXDXE3IN1OvD4Kb4glfnAw7lE9y1aqM55I5BD61rI5oQgTxabC5CvT0 > >										2
2055 //	        < 3 ; 4M ; MAY 2019 ; opt. ; - ; 0 ; 1,14145489844192 ; -1 ; -0,00025 ; 0,00025 ; 4,9 ; -7,8 ; -4,6 ; -7,6 ; 8,9 ; -9,8 ; 0,63 ; NABETHMA1962 ; E8c9cCccaBacFdccbc5cE54BFcA5BbBBCDBB7Fab6e20Fac16dE6e0Faca82d0e7 ; < 5sGtT7W5TwXnA4mAC9vvbs9Rg0Lez4S7A4X7DUl6hPO59MEbvD5KB0H3tC6Z8xZ7 > >										3
2056 //	        < 4 ; 6M ; JUL 2019 ; opt. ; - ; 0 ; 1,14236650981283 ; -1 ; -0,00025 ; 0,00025 ; 0 ; -4,4 ; -8,4 ; -1,7 ; 8 ; 0,1 ; -0,59 ; NABETHJU1995 ; Ea359E7B2baaD89e40524bD3FcA3E51524adCb9A6DBFBd50bDdac2c7Bc3977A7 ; < iJAEK75E0Ubv76Bx008GgS8gs59uxF6lb70YM5enfP1HE60O1wuin1NySixqS0D6 > >										4
2057 //	        < 5 ; 8M ; SEP 2019 ; opt. ; - ; 0 ; 1,14364357060859 ; -1 ; -0,00025 ; 0,00025 ; -9,4 ; -7,6 ; 2,7 ; -9,1 ; 8,5 ; 3,6 ; -0,41 ; NABETHSE1971 ; 4df5dEFbf3B55A34fcc9cEa4eBCE2eCcA4BdAf38cd90EeF03d26e1FAfeeEDEa9 ; < 52rKCozn97zA5MoQ7824Z2p1nLq4oX1rYupZ457g5yapQdjVw67lG33dp0bXY592 > >										5
2058 //	        < 6 ; 11M ; DEC 2019 ; opt. ; - ; 0 ; 1,14505850899257 ; -1 ; -0,00025 ; 0,00025 ; 4,5 ; 1,6 ; 1,9 ; -5,2 ; -8,3 ; -8,8 ; -0,39 ; NABETHDE1947 ; 6CECc2cD0Fa0CE9f9CF51AcDF9a8B4fAA0c3ED7EbA38B8c7b7fb23acD3cdE264 ; < Iddzjt1owEOidFRx17GlTeT2KuBF3E78lQO02q5NYB5011K14baC58w6L4K63Giv > >										6
2059 //	        < 7 ; 12M ; JAN 2020 ; opt. ; - ; 0 ; 1,1468088164366 ; -1 ; -0,00025 ; 0,00025 ; -0,5 ; -0,7 ; -1 ; -1,3 ; 0 ; -2,2 ; 0,75 ; NABETHJA2038 ; 2755a3b07Dbb6fe8BfDdCB5ceFC5acdADE0f114F37fEDC2F1b40C7eb1ddE38cc ; < c2nz3p653X412mg96Wk5zf8c1b40rruC2W8i35U3yz0r8jdHliVP4L1hwfcHlF2x > >										7
2060 //	        < 8 ; 14M ; MAR 2020 ; opt. ; - ; 0 ; 1,14870675405559 ; -1 ; -0,00025 ; 0,00025 ; -0,3 ; 3 ; 3,4 ; 1,3 ; 1,9 ; -4,9 ; -0,68 ; NABETHMA2031 ; 4d46f4adD81d1642EdcCa35CB87D1B9CC8c0B3B8Bd1AbB4efd5959e0bF83DF7d ; < c5Ph61U21D0Unfx8Mgf48C09GrD5J6ucSKPII2eGjzBY8CXq0J2cvTW85T1n2P16 > >										8
2061 //	        < 9 ; 16M ; MAY 2020 ; opt. ; - ; 0 ; 1,1508851783978 ; -1 ; -0,00025 ; 0,00025 ; -7,8 ; 2,3 ; -5 ; 8,1 ; 2,1 ; -5,6 ; -0,28 ; NABETHMA2082 ; cFcAbc9cd979fBEabCEE27bA1fb8e894eDbDdDFdcEdd05Eb3ABE7bb7e1ca0DfA ; < rqAyF2sWK93VZ2dKiS3xUVZe1wtvVm36YNBc7kqjdeyCNL62UrOEuziJhI1T0k0e > >										9
2062 //	        < 10 ; 18M ; JUL 2020 ; opt. ; - ; 0 ; 1,15322826521826 ; -1 ; -0,00025 ; 0,00025 ; -9,6 ; -1,5 ; -4,5 ; -4,8 ; 4,5 ; 9,8 ; -0,71 ; NABETHJU2056 ; 67Bd2dBed3494Ffcfad21A61bebBDADfDC7Fe6Fd939Dfcca06FAafEC83AFd394 ; < 2mw08Ah2d6acW03CMM80fxats5NCBScv9o7ZzL71Fsm2a2clHA4YWzgMp1vRA9rj > >										10
2063 //	        < 11 ; 20M ; SEP 2020 ; opt. ; - ; 0 ; 1,15581199030619 ; -1 ; -0,00025 ; 0,00025 ; 9,2 ; 4,6 ; 8,5 ; -5,7 ; -8 ; -1 ; -0,55 ; NABETHSE2052 ; f2b175edCBfb0eeAeEc83c6edF24bEdfe749A3de6C97bbcee4daAAcCbae6679F ; < WdeMg185lKS5ShGb383R1kZy22IWxkpa92dOc4dhLd6y8V8xfV3xR8F2Hvprvnzm > >										11
2064 //	        < 12 ; 23M ; DEC 2020 ; opt. ; - ; 0 ; 1,15859402976686 ; -1 ; -0,00025 ; 0,00025 ; -4,2 ; -5,9 ; 3,6 ; -0,4 ; 7 ; -8,9 ; -0,6 ; NABETHDE2069 ; 66745Bb6e3b4ffC19Ae6CfC2ed0bBbCABfeDa5A3beBaE5BA2C4AE1882D3ceD8F ; < 7Reve50cr2qveV4NoiOJ77qH0qUM7I93LOLahuda2bMojR1EkGJH5747P0S2CsSo > >										12
2065 //	        < 13 ; 24M ; JAN 2021 ; opt. ; - ; 0 ; 1,1616314175278 ; -1 ; -0,00025 ; 0,00025 ; 3,4 ; -4,4 ; 9,1 ; -6,1 ; 5,6 ; -3,9 ; -0,76 ; NABETHJA2183 ; fAddebC2a1Ced0C3F8Da9a4Fa004B4Bb557DACCD172DBDAe1a80cF32A91fBcd7 ; < 702OiSygi1357Goesgb7u8MxM3Xu5OHn4F8OU59x9zUJ233JQT210f5NVYg71m2j > >										13
2066 //	        < 14 ; 26M ; MAR 2021 ; opt. ; - ; 0 ; 1,16498188068828 ; -1 ; -0,00025 ; 0,00025 ; 6,2 ; 0 ; 7,8 ; -7,5 ; 7,5 ; 9,8 ; 0,13 ; NABETHMA2171 ; 7a4aAFAeBBD1878cdca13bE0cBbB9A0aa60AdCe69E46BeC9e8EB5E1B419C7fdC ; < 2q058Ox13HY87m44hvX70wC56Tc81290W3ZGft5H6Cvk2eT811pq9F6bc1650sGX > >										14
2067 //	        < 15 ; 28M ; MAY 2021 ; opt. ; - ; 0 ; 1,16865387556168 ; -1 ; -0,00025 ; 0,00025 ; -9 ; -7,2 ; -0,6 ; 6,4 ; -9,3 ; -9,3 ; -0,11 ; NABETHMA2177 ; bcB3CAB5daDC0D2625F15Ffd8cabcB8a2e30f0fEAB90C9c9FcCa2EaEac071a5F ; < Ypfv6XBO8xMP4KObkC0N9z35gtx6JqwX6ourv34488Kl692G7b0l8Y3VSzV3JNC5 > >										15
2068 //	        < 16 ; 30M ; JUL 2021 ; opt. ; - ; 0 ; 1,17258840763381 ; -1 ; -0,00025 ; 0,00025 ; 1,5 ; -4,9 ; 1,8 ; 1,8 ; -1,9 ; -5,5 ; 0,13 ; NABETHJU2164 ; 952ad6AAbf1edF6fA928Ddbd0cDBCf195Fb9cEBe2A54aBa43Ce2CFE7cB5bBa9e ; < dU18045tiz1MsG8aKC2465E42K0712o74LQMsJb4PmRvMQ60SzPx95D8Tkqxw03v > >										16
2069 //	        < 17 ; 32M ; SEP 2021 ; opt. ; - ; 0 ; 1,17664967976558 ; -1 ; -0,00025 ; 0,00025 ; -9,4 ; -8,1 ; 3 ; 5,3 ; -7 ; 8 ; 0,08 ; NABETHSE2199 ; d9Eb9fc1db15db9Adc136AEadBc3b7E9baDDE0EafbB39e8e8597ebb0EC534a2a ; < VKK07sCndFz66ql3b4237i24RG0V83DWsv1o568dQB49s5lLfH8wz1lLUxI1u68w > >										17
2070 //	        < 18 ; 35M ; DEC 2021 ; opt. ; - ; 0 ; 1,1810354564474 ; -1 ; -0,00025 ; 0,00025 ; 2,2 ; 5,3 ; 2,3 ; -8,3 ; -2,5 ; 9 ; 0,49 ; NABETHDE2192 ; 2B2eD30DFDBb88C3fA315dF0E7b4A1331Fa2AD71B0db03305fC32AF3532DbC72 ; < JMaHybwD6VNFJthj2EZ7ju8dvpXBPAtFB16Xwnn1xb8U6VrEV40zC629pTktMGaU > >										18
2071 //	        < 19 ; 36M ; JAN 2021 ; opt. ; - ; 0 ; 1,18570670987179 ; -1 ; -0,00025 ; 0,00025 ; 0,3 ; 1,3 ; -4,5 ; -6,8 ; 6,1 ; 9,1 ; 0,38 ; NABETHJA2155 ; bEeD0BC2a2cEc41bcbecA3BbaED46AF0bD59f4Ae4DcAC29C09DD5aaF06F8ab41 ; < Kn2yg13dkc8499i3Rw7ATZcv8mT8pqm0ZhtK84U05712huT8giNjc0I55nle9yT3 > >										19
2072 //	        < 20 ; 38M ; MAR 2021 ; opt. ; - ; 0 ; 1,19065601321761 ; -1 ; -0,00025 ; 0,00025 ; 3,8 ; 6,1 ; 7,7 ; 2,6 ; -9,4 ; 2,4 ; -0,31 ; NABETHMA2181 ; bbDe6bbbcFe2BdbEa3B8aFCfFE5fCfcDaCdDCCe1f9666bBfBadbd1A9DcdCfC35 ; < 6hVaA5f2Pr1ae1JFXLg5452c7smAXJEkz1CuBFQD7TIv30v3R2Tjj8wCp5H0q9M4 > >										20
2073 //	        < 21 ; 40M ; MAY 2021 ; opt. ; - ; 0 ; 1,19580452972815 ; -1 ; -0,00025 ; 0,00025 ; -9,2 ; -7 ; 8,8 ; 6,3 ; -2 ; 9,1 ; -0,8 ; NABETHMA2194 ; EAA8F32c1DCE3Acd3FBA0e8D30DE032fB5a06cD5dAEe0fc9D5E99be8deA0be6A ; < 7IyUUYo2M7k4gw95N3aZu1O596JbXC0I8w89NTbM9nHSJ2YBKMn1ps01UK73SudD > >										21
2074 //	        < 22 ; 42M ; JUL 2021 ; opt. ; - ; 0 ; 1,20122523958412 ; -1 ; -0,00025 ; 0,00025 ; 3 ; 3,6 ; -7,7 ; -2,5 ; 5,2 ; -5,8 ; -0,73 ; NABETHJU2120 ; AA015D8cc3ce74A16DB3FA9FEABb13733cDDFB6ebd1BeAAED3Fdb5cACFEfaa8c ; < UQ10B3C66OQXeZ8jJ4d6J7cnxy4DRJSNL9u6QOjvUFONOiecs483m4AU9qG2t5Pw > >										22
2075 //	        < 23 ; 44M ; SEP 2021 ; opt. ; - ; 0 ; 1,20697088818153 ; -1 ; -0,00025 ; 0,00025 ; -9,4 ; -8,5 ; -4,9 ; -3,1 ; -4,2 ; 3,7 ; 0,92 ; NABETHSE2119 ; 83B4D10b2C6d67A92fcFea4ABDdDBA5D3b5eDec77ebC409cdCaca6Ac28f4e04e ; < 3DXYCv5STs94OA97Z7RpsT2wYr1vtkm60uF5nYLJxtGbyqOWb09kK476USXg8TiX > >										23
2076 //	        < 24 ; 47M ; DEC 2021 ; opt. ; - ; 0 ; 1,21309173929822 ; -1 ; -0,00025 ; 0,00025 ; 0,6 ; -7,5 ; 1,4 ; -8,1 ; -9,6 ; -2,5 ; 0,68 ; NABETHDE2151 ; d3eCfccC5feFebaAcbf36c3BDc51ce8eEe6edcB9c6d9DdDA0F1f9dBb6FACBcd1 ; < td1DP04x0GskJ30Ur579Mw7k31pn4Og1um5611ANuQqiajeu98J5ZT351o0THHgc > >										24
2077 											
2078 //	  < CALLS ; 36M ; Strike ; Symbol ; Last ; T(-1) ; Change ; Volume ; BAS_1 ; BAS_2 ; o.i. @ eth_hex ; @ btc_882 >										
2079 											
2080 //	#DIV/0 !										1
2081 //	#DIV/0 !										2
2082 //	#DIV/0 !										3
2083 //	#DIV/0 !										4
2084 //	#DIV/0 !										5
2085 //	#DIV/0 !										6
2086 //	#DIV/0 !										7
2087 //	#DIV/0 !										8
2088 //	#DIV/0 !										9
2089 //	#DIV/0 !										10
2090 //	#DIV/0 !										11
2091 //	#DIV/0 !										12
2092 //	#DIV/0 !										13
2093 //	#DIV/0 !										14
2094 //	#DIV/0 !										15
2095 //	#DIV/0 !										16
2096 //	#DIV/0 !										17
2097 //	#DIV/0 !										18
2098 //	#DIV/0 !										19
2099 //	#DIV/0 !										20
2100 //	#DIV/0 !										21
2101 //											
2102 //	  < PUTS ; 36M ; Strike ; Symbol ; Last ; T(-1) ; Change ; Volume ; BAS_1 ; BAS_2 ; o.i. @ eth_hex ; @ btc_882 >										
2103 //											
2104 //	#DIV/0 !										1
2105 //	#DIV/0 !										2
2106 //	#DIV/0 !										3
2107 //	#DIV/0 !										4
2108 //	#DIV/0 !										5
2109 //	#DIV/0 !										6
2110 //	#DIV/0 !										7
2111 //	#DIV/0 !										8
2112 //	#DIV/0 !										9
2113 //	#DIV/0 !										10
2114 //	#DIV/0 !										11
2115 //	#DIV/0 !										12
2116 //	#DIV/0 !										13
2117 //	#DIV/0 !										14
2118 //	#DIV/0 !										15
2119 //	#DIV/0 !										16
2120 //	#DIV/0 !										17
2121 //	#DIV/0 !										18
2122 //	#DIV/0 !										19
2123 //	#DIV/0 !										20
2124 //	#DIV/0 !										21
2125 											
2126 											
2127 											
2128 											
2129 											
2130 //	NABBTC										
2131 											
2132 //	  < # ; REF ; Month ; Optionchain ; Chart ; Last ; T(-1) ; Change ; BAS_1 ; BAS_2 ; Prior. Settle ; Open ; High ; Low ; Volume ; Hi / Lo ; Updated (s) ; Code ; @ eth_hex ; @ btc_882 >										
2133 											
2134 //	        < 0 ; T0 ; - ; - ; - ; 0 ; 0,0000440550542260437 ; -1 ; - ; - ; - ; - ; - ; - ; - ; - ; - ; - ; EE23C8F0AAB2FCCcf514Fe30bE8D5f28bFA9c3bfDccc90FC8e6ABFc6a99fa4b4 ; < S8iBCc8103aaUo44672xd5w60P1I82Kuz5Ih2hZmf50A48N8P6di4n3vmBft11YC > >										0
2135 //	        < 1 ; 0M ; JAN 2019 ; opt. ; - ; 0 ; 0,0000440625918254867 ; -1 ; -0,00025 ; 0,00025 ; -2,2 ; -8 ; 5,7 ; -9,2 ; -2,8 ; 6,6 ; -0,15 ; NABBTC19JA19 ; 87d0EDf5AFEa1Ae2e9aD5d8badA7DDcfBBEcF0460D2C6dDD78f8D7d7AaCdc91d ; < UjRh45OBMC0s7B9qB4HjYPlX08TQKhsYl369SzY5X456PMH32j8DP8TeR4Uuw8XU > >										1
2136 //	        < 2 ; 2M ; MAR 2019 ; opt. ; - ; 0 ; 0,0000440785527635661 ; -1 ; -0,00025 ; 0,00025 ; 6,8 ; -6,1 ; 3,1 ; -4,6 ; 8,8 ; 9,6 ; -0,27 ; NABBTCMA1992 ; 3de0C8effB82FDA0C82bdA1DaFACbEbc6dFA2CfE0B30dc0aECa1faaEbcCBBEBe ; < cSh8v72P9udt5dZ76W3d8kAMv7Nn3839453YM88TjTp20Jc4MxMiPH0josYI6tpL > >										2
2137 //	        < 3 ; 4M ; MAY 2019 ; opt. ; - ; 0 ; 0,0000441069576404218 ; -1 ; -0,00025 ; 0,00025 ; -3,2 ; -1,3 ; 3,4 ; -9,1 ; 1,3 ; -5 ; 0,12 ; NABBTCMA1979 ; 2Ce1cAaadb2dDDFd3Ac2c60aE3AbDDeBdfAEFCAe0f2DEacCDF2f68AfAaF87FDD ; < 5th40B7ZCgN9bgrtG1K59F0kNe8L8wu6S3ZZ8aOr8LdeNtae1xp2aUU0iRdWgSPF > >										3
2138 //	        < 4 ; 6M ; JUL 2019 ; opt. ; - ; 0 ; 0,0000441404630431867 ; -1 ; -0,00025 ; 0,00025 ; -1,7 ; -0,3 ; -9,1 ; -9,6 ; -9,7 ; -4,4 ; 0,35 ; NABBTCJU1923 ; CBCAB777BCa1fdB8feC8F2b149f2EBd122FeEF6c6A4dFCDA5186d6aA83D4FcEC ; < kcK5plndNfWa9T8h7w1T8RQU3A8Lvnyk94dV52UmZLLKQO2Hb2rXGM7oeN71rMIV > >										4
2139 //	        < 5 ; 8M ; SEP 2019 ; opt. ; - ; 0 ; 0,000044182260006002 ; -1 ; -0,00025 ; 0,00025 ; -1,6 ; -1,3 ; -3,9 ; -0,5 ; -1,8 ; 0,2 ; -0,11 ; NABBTCSE1981 ; de54D71b3ABddDFdd419b6aDAbFAFAAFb44E0c1cC4efAfbDE0A07a2fdd83ECE5 ; < 60w650tN8i4kMZcqS0I8pE58KuP9LTyJ926ld4HMnLQ9334324dp0Z5fBZJgHJ1J > >										5
2140 //	        < 6 ; 11M ; DEC 2019 ; opt. ; - ; 0 ; 0,0000442369673518382 ; -1 ; -0,00025 ; 0,00025 ; -7,9 ; 3,1 ; 7 ; -4,7 ; 9,1 ; -7 ; -0,31 ; NABBTCDE1963 ; 8AADCC6fac34B8A3f392Fa6e2bdFe53BffFB02a5eff7aEfCF28C1CcEFBDf1a9E ; < MuPk57l9t4796WGQ3fw1wyoSSQicn9xgyO3JFN869T0X7Y5cutpb4e5faGC4M3X6 > >										6
2141 //	        < 7 ; 12M ; JAN 2020 ; opt. ; - ; 0 ; 0,0000442991014761032 ; -1 ; -0,00025 ; 0,00025 ; -8,8 ; 3,4 ; -3,3 ; 6,6 ; 0 ; -8 ; -0,56 ; NABBTCJA2010 ; 7be6ad784be3e6832F45Df1a9a1DD7deb4fE5F6b2F87e6fAFCcE80DffCafBFb2 ; < 8m8T7SXEMyMH45qbt4wQXNOnAMzS195xa27GExbOn9Avw31f2vfieO23m73X824H > >										7
2142 //	        < 8 ; 14M ; MAR 2020 ; opt. ; - ; 0 ; 0,0000443709534222985 ; -1 ; -0,00025 ; 0,00025 ; 8,5 ; -8,7 ; -8,8 ; -3,6 ; 5,6 ; -6,6 ; -0,08 ; NABBTCMA2013 ; E99FE2fa5eD9B23EcdCEd6F7be27bD9cF0F45A89F7FFfF90cFDDDfcEAF28C314 ; < F7YggcN7i24PX615se6jZrCKKQYa2n9A0G9C66Qtu10znpn2K0Wa5276db44W6AM > >										8
2143 //	        < 9 ; 16M ; MAY 2020 ; opt. ; - ; 0 ; 0,0000444515938440585 ; -1 ; -0,00025 ; 0,00025 ; -0,7 ; -5,9 ; -4,8 ; -2,1 ; -3,6 ; -4,4 ; 0,23 ; NABBTCMA2017 ; CAaBedaa4d92b75BBb49dA5FB6BfFbEdDCD04a6Ce24c131caE2ABADfd7971ceA ; < 30NY4SvYUm4l7q7IJ577GA79wvpo7C589lx7ztoo89s0M36k8xnmTOXA7Uf1gP9M > >										9
2144 //	        < 10 ; 18M ; JUL 2020 ; opt. ; - ; 0 ; 0,0000445465379912128 ; -1 ; -0,00025 ; 0,00025 ; 5,4 ; -9,6 ; -0,6 ; 3,9 ; -3 ; -7,6 ; 0,28 ; NABBTCJU2027 ; F92B9Eb5533c9d3dF6f3A1aDfCbaB459290EBF0aD2ed0bFaED2cAf38519abAFa ; < p68YlL2YEJf8Rt0i487HC7f2u6aUh97PJy950pr6i4B6j87txZEYavl7ZknAj577 > >										10
2145 //	        < 11 ; 20M ; SEP 2020 ; opt. ; - ; 0 ; 0,0000446506623238387 ; -1 ; -0,00025 ; 0,00025 ; 5,6 ; -8,9 ; -4,2 ; -1,8 ; -7,2 ; -4,5 ; -0,35 ; NABBTCSE2032 ; 2dBA0abC6Ef1aBfeFdB0ca7e8d0eCdCed6a9Fc1df0ad9BfFe4aa1e3dba71e63B ; < L82d4d6grLq0nII9x663vIU84803ottc5Ok8jEfG5LVblp569EnN0JF13qu8R440 > >										11
2146 //	        < 12 ; 23M ; DEC 2020 ; opt. ; - ; 0 ; 0,0000447662182379327 ; -1 ; -0,00025 ; 0,00025 ; -1,2 ; 0,4 ; 3,6 ; 1,5 ; -4,5 ; -9 ; -0,02 ; NABBTCDE2063 ; eBBdBBFBecAf2FBCF8DbD8FfFfFDDa17BFFAB561bBD6Aaaf51fFA2Ffdf889FeB ; < Z950Io3KLgggH3L5Q1ZxD8GT4SQO75WRZ8Qm6QYeZn1LQ5xhG7c21fvwnz4VR1eZ > >										12
2147 //	        < 13 ; 24M ; JAN 2021 ; opt. ; - ; 0 ; 0,0000448885918541723 ; -1 ; -0,00025 ; 0,00025 ; 6,6 ; -2,3 ; 7,7 ; -6,4 ; -7,7 ; 8,3 ; 0,21 ; NABBTCJA2183 ; 0bf6CAB5b1DF5f1aDDEc13dcdFE9CAaD17547e1E16eCE7aC2173CDeC4FDaad0f ; < L9P1Uma4XO1Z06xB1TaK42cE74nV5uvBreJsQgG7lvH8prD2isrj12g39UgKkxyc > >										13
2148 //	        < 14 ; 26M ; MAR 2021 ; opt. ; - ; 0 ; 0,0000450218334890655 ; -1 ; -0,00025 ; 0,00025 ; -8,1 ; -2,5 ; -4,6 ; -7 ; -7,5 ; -8,8 ; 0,66 ; NABBTCMA2137 ; CC5157E8F3C50b86aFdAA5aCC0Df7D5bddEbEEd5A9cea925B7caAF4A9cc621a2 ; < ULOA6G2x7ertNPVC3K2oJJ83XbhN42zUuurglq9iZHCGk0WbjUvRjFM8c1qRNG67 > >										14
2149 //	        < 15 ; 28M ; MAY 2021 ; opt. ; - ; 0 ; 0,0000451594191295597 ; -1 ; -0,00025 ; 0,00025 ; -3,6 ; 6,5 ; 2,7 ; 2 ; 1,9 ; -5,9 ; 0,51 ; NABBTCMA2145 ; 1706ebd6374e8EA9CC5FA22C0dcc4aE5ffb1dc8B85Caa6e35e6E1Ac97530FB64 ; < vEXqioc3dV5J8WDhqpURFKeRU9jB2N8S9MGfxC65gXB0CVZ2f983Y8YW89vL2TpU > >										15
2150 //	        < 16 ; 30M ; JUL 2021 ; opt. ; - ; 0 ; 0,0000453065810974108 ; -1 ; -0,00025 ; 0,00025 ; 2,5 ; 6,8 ; -6,6 ; -8,5 ; 4,1 ; -3,2 ; -0,38 ; NABBTCJU2131 ; 1cb2eCCe33EA5aA505C62FB4336DD48cDAE5d7aCB7b6FfBb2CE5ce4f6dbe1C4A ; < 1cLt6PLEVqUO8j4X1n8HBdkfoZpFgO9C90bWt2JgzH1oOkwCnJI8g4nE9EN68l7B > >										16
2151 //	        < 17 ; 32M ; SEP 2021 ; opt. ; - ; 0 ; 0,0000454640445907012 ; -1 ; -0,00025 ; 0,00025 ; 4,9 ; 8,4 ; 7,7 ; -1,6 ; 7 ; 5,6 ; -0,78 ; NABBTCSE2168 ; eEeAeD3e0e8dEcfEAB647edCddeaccACfe1eFc94eabBEefddebcAfDD0eB15fA9 ; < KlZ47582B9Qpu3HpzW0cSQ435P6Ibl1u5An5Wc7DCQu19Xz6Q05T8I14HV71JzD8 > >										17
2152 //	        < 18 ; 35M ; DEC 2021 ; opt. ; - ; 0 ; 0,0000456336865249775 ; -1 ; -0,00025 ; 0,00025 ; -1,7 ; 2,4 ; 5,7 ; 1,5 ; -1,8 ; -1,5 ; 0,47 ; NABBTCDE2130 ; 054bdacC248cD6fEa7B5BAC5Dbc8ec3BCEA9cfaca90DFCCbc1EB269cCbDE52CD ; < 5p9750wg2Ca2cV1W3GSpIl9hTtit25C6Km90LrdML8uR1eSMs8uhtpP1M41wzr52 > >										18
2153 //	        < 19 ; 36M ; JAN 2021 ; opt. ; - ; 0 ; 0,0000458160487126199 ; -1 ; -0,00025 ; 0,00025 ; -4 ; 1,7 ; 6,8 ; -5,8 ; 8,3 ; -8,5 ; 0,97 ; NABBTCJA2187 ; dCBFdEc1BBDbEDbB0D9c5Ecd2cf1FF0A73A8a738cbeB9A3AECD2BDFeeEf8D4ed ; < xN5PBNWYB05KW3vjtxPxhuetNCJh06QU3c7jHs66wmFnx7cn1U29Oju248576ekO > >										19
2154 //	        < 20 ; 38M ; MAR 2021 ; opt. ; - ; 0 ; 0,0000460061916339643 ; -1 ; -0,00025 ; 0,00025 ; 6 ; 3,1 ; 2,5 ; -3,6 ; 3,2 ; -8,8 ; 0,66 ; NABBTCMA2183 ; f3FF9Ce1Baa1B8B3Ab0C5AD91A2acD9baCCeda9cCc5CE8A09BCAA0Cc2d0babb9 ; < 7N6FIu4PcbU3fS0c7714P99GWTTUekVpwx0y7bExIqyz2YPt5kqGleCMU8jilO1g > >										20
2155 //	        < 21 ; 40M ; MAY 2021 ; opt. ; - ; 0 ; 0,0000462048510026623 ; -1 ; -0,00025 ; 0,00025 ; -5,4 ; -9,5 ; -2,4 ; -9,3 ; 4,8 ; -5,7 ; -0,67 ; NABBTCMA2194 ; D73AeDBAAcfd5c4d13E3013cEb77E1BADE9A5EEABAFb725e1bd2A086D7c9FAec ; < T3CGjnj1PAw8I3zHHigwU4JmDbLj4huAgEg6X8tdY9g150XLmb8eSQ0kFRZK1ZgM > >										21
2156 //	        < 22 ; 42M ; JUL 2021 ; opt. ; - ; 0 ; 0,0000464156424757591 ; -1 ; -0,00025 ; 0,00025 ; -8,3 ; -9,3 ; 6,6 ; 7,8 ; 6,2 ; 1,9 ; 0,83 ; NABBTCJU2148 ; 05cb83C7Ebda3Ec9a169Afbcbbce4ECA9dFA3db9Dd5ae7EB98A95D5d3B7beA7B ; < 92XzHi6pOmin2n7rDxKYHYs34g94G2n4WCnV2RhQdUnuep46AJuW3TTq30d9R7Zf > >										22
2157 //	        < 23 ; 44M ; SEP 2021 ; opt. ; - ; 0 ; 0,0000466337568548027 ; -1 ; -0,00025 ; 0,00025 ; -3,1 ; 2,5 ; 3,3 ; -9,5 ; 8,5 ; -3,1 ; -0,43 ; NABBTCSE2145 ; cb5B5A4AB3F4a33baEEC7fEF03BEeBCCDACC46CFADb1dFCD19Bfdd7d2dEC51b2 ; < jCak5C37O1Mp1r6Uc7dIG67RiT0a081ULv8qXJvGdQI3tScl49l5SmozApsAf4Sw > >										23
2158 //	        < 24 ; 47M ; DEC 2021 ; opt. ; - ; 0 ; 0,000046867217100057 ; -1 ; -0,00025 ; 0,00025 ; 0,5 ; -6,5 ; -6,5 ; 0,7 ; 0,6 ; 2 ; -0,2 ; NABBTCDE2133 ; b1ecB1aCECfBFEFCaD556F5BE1DEaCf8EECDF3ABBAeEcB97cFFDBe68Db4De2aa ; < z5pbs7djdM6MTWuGDFuE6xPLeCpFJSq8V7lm67rsK722v587B5wq86L4G8Se9xyh > >										24
2159 											
2160 //	  < CALLS ; 3M ; Strike ; Symbol ; Last ; T(-1) ; Change ; Volume ; BAS_1 ; BAS_2 ; o.i. @ eth_hex ; @ btc_882 >										
2161 											
2162 //	#DIV/0 !										1
2163 //	#DIV/0 !										2
2164 //	#DIV/0 !										3
2165 //	#DIV/0 !										4
2166 //	#DIV/0 !										5
2167 //	#DIV/0 !										6
2168 //	#DIV/0 !										7
2169 //	#DIV/0 !										8
2170 //	#DIV/0 !										9
2171 //	#DIV/0 !										10
2172 //	#DIV/0 !										11
2173 //	#DIV/0 !										12
2174 //	#DIV/0 !										13
2175 //	#DIV/0 !										14
2176 //	#DIV/0 !										15
2177 //	#DIV/0 !										16
2178 //	#DIV/0 !										17
2179 //	#DIV/0 !										18
2180 //	#DIV/0 !										19
2181 //	#DIV/0 !										20
2182 //	#DIV/0 !										21
2183 //											
2184 //	  < PUTS ; 3M ; Strike ; Symbol ; Last ; T(-1) ; Change ; Volume ; BAS_1 ; BAS_2 ; o.i. @ eth_hex ; @ btc_882 >										
2185 //											
2186 //	#DIV/0 !										1
2187 //	#DIV/0 !										2
2188 //	#DIV/0 !										3
2189 //	#DIV/0 !										4
2190 //	#DIV/0 !										5
2191 //	#DIV/0 !										6
2192 //	#DIV/0 !										7
2193 //	#DIV/0 !										8
2194 //	#DIV/0 !										9
2195 //	#DIV/0 !										10
2196 //	#DIV/0 !										11
2197 //	#DIV/0 !										12
2198 //	#DIV/0 !										13
2199 //	#DIV/0 !										14
2200 //	#DIV/0 !										15
2201 //	#DIV/0 !										16
2202 //	#DIV/0 !										17
2203 //	#DIV/0 !										18
2204 //	#DIV/0 !										19
2205 //	#DIV/0 !										20
2206 //	#DIV/0 !										21
2207 											
2208 											
2209 											
2210 											
2211 											
2212 //	NABBTC										
2213 											
2214 //	  < # ; REF ; Month ; Optionchain ; Chart ; Last ; T(-1) ; Change ; BAS_1 ; BAS_2 ; Prior. Settle ; Open ; High ; Low ; Volume ; Hi / Lo ; Updated (s) ; Code ; @ eth_hex ; @ btc_882 >										
2215 											
2216 //	        < 0 ; T0 ; - ; - ; - ; 0 ; 0,0000440550542260437 ; -1 ; - ; - ; - ; - ; - ; - ; - ; - ; - ; - ; EE23C8F0AAB2FCCcf514Fe30bE8D5f28bFA9c3bfDccc90FC8e6ABFc6a99fa4b4 ; < S8iBCc8103aaUo44672xd5w60P1I82Kuz5Ih2hZmf50A48N8P6di4n3vmBft11YC > >										0
2217 //	        < 1 ; 0M ; JAN 2019 ; opt. ; - ; 0 ; 0,0000440625918254867 ; -1 ; -0,00025 ; 0,00025 ; -2,2 ; -8 ; 5,7 ; -9,2 ; -2,8 ; 6,6 ; -0,15 ; NABBTC19JA19 ; 87d0EDf5AFEa1Ae2e9aD5d8badA7DDcfBBEcF0460D2C6dDD78f8D7d7AaCdc91d ; < UjRh45OBMC0s7B9qB4HjYPlX08TQKhsYl369SzY5X456PMH32j8DP8TeR4Uuw8XU > >										1
2218 //	        < 2 ; 2M ; MAR 2019 ; opt. ; - ; 0 ; 0,0000440785527635661 ; -1 ; -0,00025 ; 0,00025 ; 6,8 ; -6,1 ; 3,1 ; -4,6 ; 8,8 ; 9,6 ; -0,27 ; NABBTCMA1992 ; 3de0C8effB82FDA0C82bdA1DaFACbEbc6dFA2CfE0B30dc0aECa1faaEbcCBBEBe ; < cSh8v72P9udt5dZ76W3d8kAMv7Nn3839453YM88TjTp20Jc4MxMiPH0josYI6tpL > >										2
2219 //	        < 3 ; 4M ; MAY 2019 ; opt. ; - ; 0 ; 0,0000441069576404218 ; -1 ; -0,00025 ; 0,00025 ; -3,2 ; -1,3 ; 3,4 ; -9,1 ; 1,3 ; -5 ; 0,12 ; NABBTCMA1979 ; 2Ce1cAaadb2dDDFd3Ac2c60aE3AbDDeBdfAEFCAe0f2DEacCDF2f68AfAaF87FDD ; < 5th40B7ZCgN9bgrtG1K59F0kNe8L8wu6S3ZZ8aOr8LdeNtae1xp2aUU0iRdWgSPF > >										3
2220 //	        < 4 ; 6M ; JUL 2019 ; opt. ; - ; 0 ; 0,0000441404630431867 ; -1 ; -0,00025 ; 0,00025 ; -1,7 ; -0,3 ; -9,1 ; -9,6 ; -9,7 ; -4,4 ; 0,35 ; NABBTCJU1923 ; CBCAB777BCa1fdB8feC8F2b149f2EBd122FeEF6c6A4dFCDA5186d6aA83D4FcEC ; < kcK5plndNfWa9T8h7w1T8RQU3A8Lvnyk94dV52UmZLLKQO2Hb2rXGM7oeN71rMIV > >										4
2221 //	        < 5 ; 8M ; SEP 2019 ; opt. ; - ; 0 ; 0,000044182260006002 ; -1 ; -0,00025 ; 0,00025 ; -1,6 ; -1,3 ; -3,9 ; -0,5 ; -1,8 ; 0,2 ; -0,11 ; NABBTCSE1981 ; de54D71b3ABddDFdd419b6aDAbFAFAAFb44E0c1cC4efAfbDE0A07a2fdd83ECE5 ; < 60w650tN8i4kMZcqS0I8pE58KuP9LTyJ926ld4HMnLQ9334324dp0Z5fBZJgHJ1J > >										5
2222 //	        < 6 ; 11M ; DEC 2019 ; opt. ; - ; 0 ; 0,0000442369673518382 ; -1 ; -0,00025 ; 0,00025 ; -7,9 ; 3,1 ; 7 ; -4,7 ; 9,1 ; -7 ; -0,31 ; NABBTCDE1963 ; 8AADCC6fac34B8A3f392Fa6e2bdFe53BffFB02a5eff7aEfCF28C1CcEFBDf1a9E ; < MuPk57l9t4796WGQ3fw1wyoSSQicn9xgyO3JFN869T0X7Y5cutpb4e5faGC4M3X6 > >										6
2223 //	        < 7 ; 12M ; JAN 2020 ; opt. ; - ; 0 ; 0,0000442991014761032 ; -1 ; -0,00025 ; 0,00025 ; -8,8 ; 3,4 ; -3,3 ; 6,6 ; 0 ; -8 ; -0,56 ; NABBTCJA2010 ; 7be6ad784be3e6832F45Df1a9a1DD7deb4fE5F6b2F87e6fAFCcE80DffCafBFb2 ; < 8m8T7SXEMyMH45qbt4wQXNOnAMzS195xa27GExbOn9Avw31f2vfieO23m73X824H > >										7
2224 //	        < 8 ; 14M ; MAR 2020 ; opt. ; - ; 0 ; 0,0000443709534222985 ; -1 ; -0,00025 ; 0,00025 ; 8,5 ; -8,7 ; -8,8 ; -3,6 ; 5,6 ; -6,6 ; -0,08 ; NABBTCMA2013 ; E99FE2fa5eD9B23EcdCEd6F7be27bD9cF0F45A89F7FFfF90cFDDDfcEAF28C314 ; < F7YggcN7i24PX615se6jZrCKKQYa2n9A0G9C66Qtu10znpn2K0Wa5276db44W6AM > >										8
2225 //	        < 9 ; 16M ; MAY 2020 ; opt. ; - ; 0 ; 0,0000444515938440585 ; -1 ; -0,00025 ; 0,00025 ; -0,7 ; -5,9 ; -4,8 ; -2,1 ; -3,6 ; -4,4 ; 0,23 ; NABBTCMA2017 ; CAaBedaa4d92b75BBb49dA5FB6BfFbEdDCD04a6Ce24c131caE2ABADfd7971ceA ; < 30NY4SvYUm4l7q7IJ577GA79wvpo7C589lx7ztoo89s0M36k8xnmTOXA7Uf1gP9M > >										9
2226 //	        < 10 ; 18M ; JUL 2020 ; opt. ; - ; 0 ; 0,0000445465379912128 ; -1 ; -0,00025 ; 0,00025 ; 5,4 ; -9,6 ; -0,6 ; 3,9 ; -3 ; -7,6 ; 0,28 ; NABBTCJU2027 ; F92B9Eb5533c9d3dF6f3A1aDfCbaB459290EBF0aD2ed0bFaED2cAf38519abAFa ; < p68YlL2YEJf8Rt0i487HC7f2u6aUh97PJy950pr6i4B6j87txZEYavl7ZknAj577 > >										10
2227 //	        < 11 ; 20M ; SEP 2020 ; opt. ; - ; 0 ; 0,0000446506623238387 ; -1 ; -0,00025 ; 0,00025 ; 5,6 ; -8,9 ; -4,2 ; -1,8 ; -7,2 ; -4,5 ; -0,35 ; NABBTCSE2032 ; 2dBA0abC6Ef1aBfeFdB0ca7e8d0eCdCed6a9Fc1df0ad9BfFe4aa1e3dba71e63B ; < L82d4d6grLq0nII9x663vIU84803ottc5Ok8jEfG5LVblp569EnN0JF13qu8R440 > >										11
2228 //	        < 12 ; 23M ; DEC 2020 ; opt. ; - ; 0 ; 0,0000447662182379327 ; -1 ; -0,00025 ; 0,00025 ; -1,2 ; 0,4 ; 3,6 ; 1,5 ; -4,5 ; -9 ; -0,02 ; NABBTCDE2063 ; eBBdBBFBecAf2FBCF8DbD8FfFfFDDa17BFFAB561bBD6Aaaf51fFA2Ffdf889FeB ; < Z950Io3KLgggH3L5Q1ZxD8GT4SQO75WRZ8Qm6QYeZn1LQ5xhG7c21fvwnz4VR1eZ > >										12
2229 //	        < 13 ; 24M ; JAN 2021 ; opt. ; - ; 0 ; 0,0000448885918541723 ; -1 ; -0,00025 ; 0,00025 ; 6,6 ; -2,3 ; 7,7 ; -6,4 ; -7,7 ; 8,3 ; 0,21 ; NABBTCJA2183 ; 0bf6CAB5b1DF5f1aDDEc13dcdFE9CAaD17547e1E16eCE7aC2173CDeC4FDaad0f ; < L9P1Uma4XO1Z06xB1TaK42cE74nV5uvBreJsQgG7lvH8prD2isrj12g39UgKkxyc > >										13
2230 //	        < 14 ; 26M ; MAR 2021 ; opt. ; - ; 0 ; 0,0000450218334890655 ; -1 ; -0,00025 ; 0,00025 ; -8,1 ; -2,5 ; -4,6 ; -7 ; -7,5 ; -8,8 ; 0,66 ; NABBTCMA2137 ; CC5157E8F3C50b86aFdAA5aCC0Df7D5bddEbEEd5A9cea925B7caAF4A9cc621a2 ; < ULOA6G2x7ertNPVC3K2oJJ83XbhN42zUuurglq9iZHCGk0WbjUvRjFM8c1qRNG67 > >										14
2231 //	        < 15 ; 28M ; MAY 2021 ; opt. ; - ; 0 ; 0,0000451594191295597 ; -1 ; -0,00025 ; 0,00025 ; -3,6 ; 6,5 ; 2,7 ; 2 ; 1,9 ; -5,9 ; 0,51 ; NABBTCMA2145 ; 1706ebd6374e8EA9CC5FA22C0dcc4aE5ffb1dc8B85Caa6e35e6E1Ac97530FB64 ; < vEXqioc3dV5J8WDhqpURFKeRU9jB2N8S9MGfxC65gXB0CVZ2f983Y8YW89vL2TpU > >										15
2232 //	        < 16 ; 30M ; JUL 2021 ; opt. ; - ; 0 ; 0,0000453065810974108 ; -1 ; -0,00025 ; 0,00025 ; 2,5 ; 6,8 ; -6,6 ; -8,5 ; 4,1 ; -3,2 ; -0,38 ; NABBTCJU2131 ; 1cb2eCCe33EA5aA505C62FB4336DD48cDAE5d7aCB7b6FfBb2CE5ce4f6dbe1C4A ; < 1cLt6PLEVqUO8j4X1n8HBdkfoZpFgO9C90bWt2JgzH1oOkwCnJI8g4nE9EN68l7B > >										16
2233 //	        < 17 ; 32M ; SEP 2021 ; opt. ; - ; 0 ; 0,0000454640445907012 ; -1 ; -0,00025 ; 0,00025 ; 4,9 ; 8,4 ; 7,7 ; -1,6 ; 7 ; 5,6 ; -0,78 ; NABBTCSE2168 ; eEeAeD3e0e8dEcfEAB647edCddeaccACfe1eFc94eabBEefddebcAfDD0eB15fA9 ; < KlZ47582B9Qpu3HpzW0cSQ435P6Ibl1u5An5Wc7DCQu19Xz6Q05T8I14HV71JzD8 > >										17
2234 //	        < 18 ; 35M ; DEC 2021 ; opt. ; - ; 0 ; 0,0000456336865249775 ; -1 ; -0,00025 ; 0,00025 ; -1,7 ; 2,4 ; 5,7 ; 1,5 ; -1,8 ; -1,5 ; 0,47 ; NABBTCDE2130 ; 054bdacC248cD6fEa7B5BAC5Dbc8ec3BCEA9cfaca90DFCCbc1EB269cCbDE52CD ; < 5p9750wg2Ca2cV1W3GSpIl9hTtit25C6Km90LrdML8uR1eSMs8uhtpP1M41wzr52 > >										18
2235 //	        < 19 ; 36M ; JAN 2021 ; opt. ; - ; 0 ; 0,0000458160487126199 ; -1 ; -0,00025 ; 0,00025 ; -4 ; 1,7 ; 6,8 ; -5,8 ; 8,3 ; -8,5 ; 0,97 ; NABBTCJA2187 ; dCBFdEc1BBDbEDbB0D9c5Ecd2cf1FF0A73A8a738cbeB9A3AECD2BDFeeEf8D4ed ; < xN5PBNWYB05KW3vjtxPxhuetNCJh06QU3c7jHs66wmFnx7cn1U29Oju248576ekO > >										19
2236 //	        < 20 ; 38M ; MAR 2021 ; opt. ; - ; 0 ; 0,0000460061916339643 ; -1 ; -0,00025 ; 0,00025 ; 6 ; 3,1 ; 2,5 ; -3,6 ; 3,2 ; -8,8 ; 0,66 ; NABBTCMA2183 ; f3FF9Ce1Baa1B8B3Ab0C5AD91A2acD9baCCeda9cCc5CE8A09BCAA0Cc2d0babb9 ; < 7N6FIu4PcbU3fS0c7714P99GWTTUekVpwx0y7bExIqyz2YPt5kqGleCMU8jilO1g > >										20
2237 //	        < 21 ; 40M ; MAY 2021 ; opt. ; - ; 0 ; 0,0000462048510026623 ; -1 ; -0,00025 ; 0,00025 ; -5,4 ; -9,5 ; -2,4 ; -9,3 ; 4,8 ; -5,7 ; -0,67 ; NABBTCMA2194 ; D73AeDBAAcfd5c4d13E3013cEb77E1BADE9A5EEABAFb725e1bd2A086D7c9FAec ; < T3CGjnj1PAw8I3zHHigwU4JmDbLj4huAgEg6X8tdY9g150XLmb8eSQ0kFRZK1ZgM > >										21
2238 //	        < 22 ; 42M ; JUL 2021 ; opt. ; - ; 0 ; 0,0000464156424757591 ; -1 ; -0,00025 ; 0,00025 ; -8,3 ; -9,3 ; 6,6 ; 7,8 ; 6,2 ; 1,9 ; 0,83 ; NABBTCJU2148 ; 05cb83C7Ebda3Ec9a169Afbcbbce4ECA9dFA3db9Dd5ae7EB98A95D5d3B7beA7B ; < 92XzHi6pOmin2n7rDxKYHYs34g94G2n4WCnV2RhQdUnuep46AJuW3TTq30d9R7Zf > >										22
2239 //	        < 23 ; 44M ; SEP 2021 ; opt. ; - ; 0 ; 0,0000466337568548027 ; -1 ; -0,00025 ; 0,00025 ; -3,1 ; 2,5 ; 3,3 ; -9,5 ; 8,5 ; -3,1 ; -0,43 ; NABBTCSE2145 ; cb5B5A4AB3F4a33baEEC7fEF03BEeBCCDACC46CFADb1dFCD19Bfdd7d2dEC51b2 ; < jCak5C37O1Mp1r6Uc7dIG67RiT0a081ULv8qXJvGdQI3tScl49l5SmozApsAf4Sw > >										23
2240 //	        < 24 ; 47M ; DEC 2021 ; opt. ; - ; 0 ; 0,000046867217100057 ; -1 ; -0,00025 ; 0,00025 ; 0,5 ; -6,5 ; -6,5 ; 0,7 ; 0,6 ; 2 ; -0,2 ; NABBTCDE2133 ; b1ecB1aCECfBFEFCaD556F5BE1DEaCf8EECDF3ABBAeEcB97cFFDBe68Db4De2aa ; < z5pbs7djdM6MTWuGDFuE6xPLeCpFJSq8V7lm67rsK722v587B5wq86L4G8Se9xyh > >										24
2241 											
2242 //	  < CALLS ; 6M ; Strike ; Symbol ; Last ; T(-1) ; Change ; Volume ; BAS_1 ; BAS_2 ; o.i. @ eth_hex ; @ btc_882 >										
2243 											
2244 //	#DIV/0 !										1
2245 //	#DIV/0 !										2
2246 //	#DIV/0 !										3
2247 //	#DIV/0 !										4
2248 //	#DIV/0 !										5
2249 //	#DIV/0 !										6
2250 //	#DIV/0 !										7
2251 //	#DIV/0 !										8
2252 //	#DIV/0 !										9
2253 //	#DIV/0 !										10
2254 //	#DIV/0 !										11
2255 //	#DIV/0 !										12
2256 //	#DIV/0 !										13
2257 //	#DIV/0 !										14
2258 //	#DIV/0 !										15
2259 //	#DIV/0 !										16
2260 //	#DIV/0 !										17
2261 //	#DIV/0 !										18
2262 //	#DIV/0 !										19
2263 //	#DIV/0 !										20
2264 //	#DIV/0 !										21
2265 //											
2266 //	  < PUTS ; 6M ; Strike ; Symbol ; Last ; T(-1) ; Change ; Volume ; BAS_1 ; BAS_2 ; o.i. @ eth_hex ; @ btc_882 >										
2267 //											
2268 //	#DIV/0 !										1
2269 //	#DIV/0 !										2
2270 //	#DIV/0 !										3
2271 //	#DIV/0 !										4
2272 //	#DIV/0 !										5
2273 //	#DIV/0 !										6
2274 //	#DIV/0 !										7
2275 //	#DIV/0 !										8
2276 //	#DIV/0 !										9
2277 //	#DIV/0 !										10
2278 //	#DIV/0 !										11
2279 //	#DIV/0 !										12
2280 //	#DIV/0 !										13
2281 //	#DIV/0 !										14
2282 //	#DIV/0 !										15
2283 //	#DIV/0 !										16
2284 //	#DIV/0 !										17
2285 //	#DIV/0 !										18
2286 //	#DIV/0 !										19
2287 //	#DIV/0 !										20
2288 //	#DIV/0 !										21
2289 											
2290 											
2291 											
2292 											
2293 											
2294 //	NABBTC										
2295 											
2296 //	  < # ; REF ; Month ; Optionchain ; Chart ; Last ; T(-1) ; Change ; BAS_1 ; BAS_2 ; Prior. Settle ; Open ; High ; Low ; Volume ; Hi / Lo ; Updated (s) ; Code ; @ eth_hex ; @ btc_882 >										
2297 											
2298 //	        < 0 ; T0 ; - ; - ; - ; 0 ; 0,0000440550542260437 ; -1 ; - ; - ; - ; - ; - ; - ; - ; - ; - ; - ; EE23C8F0AAB2FCCcf514Fe30bE8D5f28bFA9c3bfDccc90FC8e6ABFc6a99fa4b4 ; < S8iBCc8103aaUo44672xd5w60P1I82Kuz5Ih2hZmf50A48N8P6di4n3vmBft11YC > >										0
2299 //	        < 1 ; 0M ; JAN 2019 ; opt. ; - ; 0 ; 0,0000440625918254867 ; -1 ; -0,00025 ; 0,00025 ; -2,2 ; -8 ; 5,7 ; -9,2 ; -2,8 ; 6,6 ; -0,15 ; NABBTC19JA19 ; 87d0EDf5AFEa1Ae2e9aD5d8badA7DDcfBBEcF0460D2C6dDD78f8D7d7AaCdc91d ; < UjRh45OBMC0s7B9qB4HjYPlX08TQKhsYl369SzY5X456PMH32j8DP8TeR4Uuw8XU > >										1
2300 //	        < 2 ; 2M ; MAR 2019 ; opt. ; - ; 0 ; 0,0000440785527635661 ; -1 ; -0,00025 ; 0,00025 ; 6,8 ; -6,1 ; 3,1 ; -4,6 ; 8,8 ; 9,6 ; -0,27 ; NABBTCMA1992 ; 3de0C8effB82FDA0C82bdA1DaFACbEbc6dFA2CfE0B30dc0aECa1faaEbcCBBEBe ; < cSh8v72P9udt5dZ76W3d8kAMv7Nn3839453YM88TjTp20Jc4MxMiPH0josYI6tpL > >										2
2301 //	        < 3 ; 4M ; MAY 2019 ; opt. ; - ; 0 ; 0,0000441069576404218 ; -1 ; -0,00025 ; 0,00025 ; -3,2 ; -1,3 ; 3,4 ; -9,1 ; 1,3 ; -5 ; 0,12 ; NABBTCMA1979 ; 2Ce1cAaadb2dDDFd3Ac2c60aE3AbDDeBdfAEFCAe0f2DEacCDF2f68AfAaF87FDD ; < 5th40B7ZCgN9bgrtG1K59F0kNe8L8wu6S3ZZ8aOr8LdeNtae1xp2aUU0iRdWgSPF > >										3
2302 //	        < 4 ; 6M ; JUL 2019 ; opt. ; - ; 0 ; 0,0000441404630431867 ; -1 ; -0,00025 ; 0,00025 ; -1,7 ; -0,3 ; -9,1 ; -9,6 ; -9,7 ; -4,4 ; 0,35 ; NABBTCJU1923 ; CBCAB777BCa1fdB8feC8F2b149f2EBd122FeEF6c6A4dFCDA5186d6aA83D4FcEC ; < kcK5plndNfWa9T8h7w1T8RQU3A8Lvnyk94dV52UmZLLKQO2Hb2rXGM7oeN71rMIV > >										4
2303 //	        < 5 ; 8M ; SEP 2019 ; opt. ; - ; 0 ; 0,000044182260006002 ; -1 ; -0,00025 ; 0,00025 ; -1,6 ; -1,3 ; -3,9 ; -0,5 ; -1,8 ; 0,2 ; -0,11 ; NABBTCSE1981 ; de54D71b3ABddDFdd419b6aDAbFAFAAFb44E0c1cC4efAfbDE0A07a2fdd83ECE5 ; < 60w650tN8i4kMZcqS0I8pE58KuP9LTyJ926ld4HMnLQ9334324dp0Z5fBZJgHJ1J > >										5
2304 //	        < 6 ; 11M ; DEC 2019 ; opt. ; - ; 0 ; 0,0000442369673518382 ; -1 ; -0,00025 ; 0,00025 ; -7,9 ; 3,1 ; 7 ; -4,7 ; 9,1 ; -7 ; -0,31 ; NABBTCDE1963 ; 8AADCC6fac34B8A3f392Fa6e2bdFe53BffFB02a5eff7aEfCF28C1CcEFBDf1a9E ; < MuPk57l9t4796WGQ3fw1wyoSSQicn9xgyO3JFN869T0X7Y5cutpb4e5faGC4M3X6 > >										6
2305 //	        < 7 ; 12M ; JAN 2020 ; opt. ; - ; 0 ; 0,0000442991014761032 ; -1 ; -0,00025 ; 0,00025 ; -8,8 ; 3,4 ; -3,3 ; 6,6 ; 0 ; -8 ; -0,56 ; NABBTCJA2010 ; 7be6ad784be3e6832F45Df1a9a1DD7deb4fE5F6b2F87e6fAFCcE80DffCafBFb2 ; < 8m8T7SXEMyMH45qbt4wQXNOnAMzS195xa27GExbOn9Avw31f2vfieO23m73X824H > >										7
2306 //	        < 8 ; 14M ; MAR 2020 ; opt. ; - ; 0 ; 0,0000443709534222985 ; -1 ; -0,00025 ; 0,00025 ; 8,5 ; -8,7 ; -8,8 ; -3,6 ; 5,6 ; -6,6 ; -0,08 ; NABBTCMA2013 ; E99FE2fa5eD9B23EcdCEd6F7be27bD9cF0F45A89F7FFfF90cFDDDfcEAF28C314 ; < F7YggcN7i24PX615se6jZrCKKQYa2n9A0G9C66Qtu10znpn2K0Wa5276db44W6AM > >										8
2307 //	        < 9 ; 16M ; MAY 2020 ; opt. ; - ; 0 ; 0,0000444515938440585 ; -1 ; -0,00025 ; 0,00025 ; -0,7 ; -5,9 ; -4,8 ; -2,1 ; -3,6 ; -4,4 ; 0,23 ; NABBTCMA2017 ; CAaBedaa4d92b75BBb49dA5FB6BfFbEdDCD04a6Ce24c131caE2ABADfd7971ceA ; < 30NY4SvYUm4l7q7IJ577GA79wvpo7C589lx7ztoo89s0M36k8xnmTOXA7Uf1gP9M > >										9
2308 //	        < 10 ; 18M ; JUL 2020 ; opt. ; - ; 0 ; 0,0000445465379912128 ; -1 ; -0,00025 ; 0,00025 ; 5,4 ; -9,6 ; -0,6 ; 3,9 ; -3 ; -7,6 ; 0,28 ; NABBTCJU2027 ; F92B9Eb5533c9d3dF6f3A1aDfCbaB459290EBF0aD2ed0bFaED2cAf38519abAFa ; < p68YlL2YEJf8Rt0i487HC7f2u6aUh97PJy950pr6i4B6j87txZEYavl7ZknAj577 > >										10
2309 //	        < 11 ; 20M ; SEP 2020 ; opt. ; - ; 0 ; 0,0000446506623238387 ; -1 ; -0,00025 ; 0,00025 ; 5,6 ; -8,9 ; -4,2 ; -1,8 ; -7,2 ; -4,5 ; -0,35 ; NABBTCSE2032 ; 2dBA0abC6Ef1aBfeFdB0ca7e8d0eCdCed6a9Fc1df0ad9BfFe4aa1e3dba71e63B ; < L82d4d6grLq0nII9x663vIU84803ottc5Ok8jEfG5LVblp569EnN0JF13qu8R440 > >										11
2310 //	        < 12 ; 23M ; DEC 2020 ; opt. ; - ; 0 ; 0,0000447662182379327 ; -1 ; -0,00025 ; 0,00025 ; -1,2 ; 0,4 ; 3,6 ; 1,5 ; -4,5 ; -9 ; -0,02 ; NABBTCDE2063 ; eBBdBBFBecAf2FBCF8DbD8FfFfFDDa17BFFAB561bBD6Aaaf51fFA2Ffdf889FeB ; < Z950Io3KLgggH3L5Q1ZxD8GT4SQO75WRZ8Qm6QYeZn1LQ5xhG7c21fvwnz4VR1eZ > >										12
2311 //	        < 13 ; 24M ; JAN 2021 ; opt. ; - ; 0 ; 0,0000448885918541723 ; -1 ; -0,00025 ; 0,00025 ; 6,6 ; -2,3 ; 7,7 ; -6,4 ; -7,7 ; 8,3 ; 0,21 ; NABBTCJA2183 ; 0bf6CAB5b1DF5f1aDDEc13dcdFE9CAaD17547e1E16eCE7aC2173CDeC4FDaad0f ; < L9P1Uma4XO1Z06xB1TaK42cE74nV5uvBreJsQgG7lvH8prD2isrj12g39UgKkxyc > >										13
2312 //	        < 14 ; 26M ; MAR 2021 ; opt. ; - ; 0 ; 0,0000450218334890655 ; -1 ; -0,00025 ; 0,00025 ; -8,1 ; -2,5 ; -4,6 ; -7 ; -7,5 ; -8,8 ; 0,66 ; NABBTCMA2137 ; CC5157E8F3C50b86aFdAA5aCC0Df7D5bddEbEEd5A9cea925B7caAF4A9cc621a2 ; < ULOA6G2x7ertNPVC3K2oJJ83XbhN42zUuurglq9iZHCGk0WbjUvRjFM8c1qRNG67 > >										14
2313 //	        < 15 ; 28M ; MAY 2021 ; opt. ; - ; 0 ; 0,0000451594191295597 ; -1 ; -0,00025 ; 0,00025 ; -3,6 ; 6,5 ; 2,7 ; 2 ; 1,9 ; -5,9 ; 0,51 ; NABBTCMA2145 ; 1706ebd6374e8EA9CC5FA22C0dcc4aE5ffb1dc8B85Caa6e35e6E1Ac97530FB64 ; < vEXqioc3dV5J8WDhqpURFKeRU9jB2N8S9MGfxC65gXB0CVZ2f983Y8YW89vL2TpU > >										15
2314 //	        < 16 ; 30M ; JUL 2021 ; opt. ; - ; 0 ; 0,0000453065810974108 ; -1 ; -0,00025 ; 0,00025 ; 2,5 ; 6,8 ; -6,6 ; -8,5 ; 4,1 ; -3,2 ; -0,38 ; NABBTCJU2131 ; 1cb2eCCe33EA5aA505C62FB4336DD48cDAE5d7aCB7b6FfBb2CE5ce4f6dbe1C4A ; < 1cLt6PLEVqUO8j4X1n8HBdkfoZpFgO9C90bWt2JgzH1oOkwCnJI8g4nE9EN68l7B > >										16
2315 //	        < 17 ; 32M ; SEP 2021 ; opt. ; - ; 0 ; 0,0000454640445907012 ; -1 ; -0,00025 ; 0,00025 ; 4,9 ; 8,4 ; 7,7 ; -1,6 ; 7 ; 5,6 ; -0,78 ; NABBTCSE2168 ; eEeAeD3e0e8dEcfEAB647edCddeaccACfe1eFc94eabBEefddebcAfDD0eB15fA9 ; < KlZ47582B9Qpu3HpzW0cSQ435P6Ibl1u5An5Wc7DCQu19Xz6Q05T8I14HV71JzD8 > >										17
2316 //	        < 18 ; 35M ; DEC 2021 ; opt. ; - ; 0 ; 0,0000456336865249775 ; -1 ; -0,00025 ; 0,00025 ; -1,7 ; 2,4 ; 5,7 ; 1,5 ; -1,8 ; -1,5 ; 0,47 ; NABBTCDE2130 ; 054bdacC248cD6fEa7B5BAC5Dbc8ec3BCEA9cfaca90DFCCbc1EB269cCbDE52CD ; < 5p9750wg2Ca2cV1W3GSpIl9hTtit25C6Km90LrdML8uR1eSMs8uhtpP1M41wzr52 > >										18
2317 //	        < 19 ; 36M ; JAN 2021 ; opt. ; - ; 0 ; 0,0000458160487126199 ; -1 ; -0,00025 ; 0,00025 ; -4 ; 1,7 ; 6,8 ; -5,8 ; 8,3 ; -8,5 ; 0,97 ; NABBTCJA2187 ; dCBFdEc1BBDbEDbB0D9c5Ecd2cf1FF0A73A8a738cbeB9A3AECD2BDFeeEf8D4ed ; < xN5PBNWYB05KW3vjtxPxhuetNCJh06QU3c7jHs66wmFnx7cn1U29Oju248576ekO > >										19
2318 //	        < 20 ; 38M ; MAR 2021 ; opt. ; - ; 0 ; 0,0000460061916339643 ; -1 ; -0,00025 ; 0,00025 ; 6 ; 3,1 ; 2,5 ; -3,6 ; 3,2 ; -8,8 ; 0,66 ; NABBTCMA2183 ; f3FF9Ce1Baa1B8B3Ab0C5AD91A2acD9baCCeda9cCc5CE8A09BCAA0Cc2d0babb9 ; < 7N6FIu4PcbU3fS0c7714P99GWTTUekVpwx0y7bExIqyz2YPt5kqGleCMU8jilO1g > >										20
2319 //	        < 21 ; 40M ; MAY 2021 ; opt. ; - ; 0 ; 0,0000462048510026623 ; -1 ; -0,00025 ; 0,00025 ; -5,4 ; -9,5 ; -2,4 ; -9,3 ; 4,8 ; -5,7 ; -0,67 ; NABBTCMA2194 ; D73AeDBAAcfd5c4d13E3013cEb77E1BADE9A5EEABAFb725e1bd2A086D7c9FAec ; < T3CGjnj1PAw8I3zHHigwU4JmDbLj4huAgEg6X8tdY9g150XLmb8eSQ0kFRZK1ZgM > >										21
2320 //	        < 22 ; 42M ; JUL 2021 ; opt. ; - ; 0 ; 0,0000464156424757591 ; -1 ; -0,00025 ; 0,00025 ; -8,3 ; -9,3 ; 6,6 ; 7,8 ; 6,2 ; 1,9 ; 0,83 ; NABBTCJU2148 ; 05cb83C7Ebda3Ec9a169Afbcbbce4ECA9dFA3db9Dd5ae7EB98A95D5d3B7beA7B ; < 92XzHi6pOmin2n7rDxKYHYs34g94G2n4WCnV2RhQdUnuep46AJuW3TTq30d9R7Zf > >										22
2321 //	        < 23 ; 44M ; SEP 2021 ; opt. ; - ; 0 ; 0,0000466337568548027 ; -1 ; -0,00025 ; 0,00025 ; -3,1 ; 2,5 ; 3,3 ; -9,5 ; 8,5 ; -3,1 ; -0,43 ; NABBTCSE2145 ; cb5B5A4AB3F4a33baEEC7fEF03BEeBCCDACC46CFADb1dFCD19Bfdd7d2dEC51b2 ; < jCak5C37O1Mp1r6Uc7dIG67RiT0a081ULv8qXJvGdQI3tScl49l5SmozApsAf4Sw > >										23
2322 //	        < 24 ; 47M ; DEC 2021 ; opt. ; - ; 0 ; 0,000046867217100057 ; -1 ; -0,00025 ; 0,00025 ; 0,5 ; -6,5 ; -6,5 ; 0,7 ; 0,6 ; 2 ; -0,2 ; NABBTCDE2133 ; b1ecB1aCECfBFEFCaD556F5BE1DEaCf8EECDF3ABBAeEcB97cFFDBe68Db4De2aa ; < z5pbs7djdM6MTWuGDFuE6xPLeCpFJSq8V7lm67rsK722v587B5wq86L4G8Se9xyh > >										24
2323 											
2324 //	  < CALLS ; 12M ; Strike ; Symbol ; Last ; T(-1) ; Change ; Volume ; BAS_1 ; BAS_2 ; o.i. @ eth_hex ; @ btc_882 >										
2325 											
2326 //	#DIV/0 !										1
2327 //	#DIV/0 !										2
2328 //	#DIV/0 !										3
2329 //	#DIV/0 !										4
2330 //	#DIV/0 !										5
2331 //	#DIV/0 !										6
2332 //	#DIV/0 !										7
2333 //	#DIV/0 !										8
2334 //	#DIV/0 !										9
2335 //	#DIV/0 !										10
2336 //	#DIV/0 !										11
2337 //	#DIV/0 !										12
2338 //	#DIV/0 !										13
2339 //	#DIV/0 !										14
2340 //	#DIV/0 !										15
2341 //	#DIV/0 !										16
2342 //	#DIV/0 !										17
2343 //	#DIV/0 !										18
2344 //	#DIV/0 !										19
2345 //	#DIV/0 !										20
2346 //	#DIV/0 !										21
2347 //											
2348 //	  < PUTS ; 12M ; Strike ; Symbol ; Last ; T(-1) ; Change ; Volume ; BAS_1 ; BAS_2 ; o.i. @ eth_hex ; @ btc_882 >										
2349 //											
2350 //	#DIV/0 !										1
2351 //	#DIV/0 !										2
2352 //	#DIV/0 !										3
2353 //	#DIV/0 !										4
2354 //	#DIV/0 !										5
2355 //	#DIV/0 !										6
2356 //	#DIV/0 !										7
2357 //	#DIV/0 !										8
2358 //	#DIV/0 !										9
2359 //	#DIV/0 !										10
2360 //	#DIV/0 !										11
2361 //	#DIV/0 !										12
2362 //	#DIV/0 !										13
2363 //	#DIV/0 !										14
2364 //	#DIV/0 !										15
2365 //	#DIV/0 !										16
2366 //	#DIV/0 !										17
2367 //	#DIV/0 !										18
2368 //	#DIV/0 !										19
2369 //	#DIV/0 !										20
2370 //	#DIV/0 !										21
2371 											
2372 											
2373 											
2374 											
2375 											
2376 //	NABBTC										
2377 											
2378 //	  < # ; REF ; Month ; Optionchain ; Chart ; Last ; T(-1) ; Change ; BAS_1 ; BAS_2 ; Prior. Settle ; Open ; High ; Low ; Volume ; Hi / Lo ; Updated (s) ; Code ; @ eth_hex ; @ btc_882 >										
2379 											
2380 //	        < 0 ; T0 ; - ; - ; - ; 0 ; 0,0000440550542260437 ; -1 ; - ; - ; - ; - ; - ; - ; - ; - ; - ; - ; EE23C8F0AAB2FCCcf514Fe30bE8D5f28bFA9c3bfDccc90FC8e6ABFc6a99fa4b4 ; < S8iBCc8103aaUo44672xd5w60P1I82Kuz5Ih2hZmf50A48N8P6di4n3vmBft11YC > >										0
2381 //	        < 1 ; 0M ; JAN 2019 ; opt. ; - ; 0 ; 0,0000440625918254867 ; -1 ; -0,00025 ; 0,00025 ; -2,2 ; -8 ; 5,7 ; -9,2 ; -2,8 ; 6,6 ; -0,15 ; NABBTC19JA19 ; 87d0EDf5AFEa1Ae2e9aD5d8badA7DDcfBBEcF0460D2C6dDD78f8D7d7AaCdc91d ; < UjRh45OBMC0s7B9qB4HjYPlX08TQKhsYl369SzY5X456PMH32j8DP8TeR4Uuw8XU > >										1
2382 //	        < 2 ; 2M ; MAR 2019 ; opt. ; - ; 0 ; 0,0000440785527635661 ; -1 ; -0,00025 ; 0,00025 ; 6,8 ; -6,1 ; 3,1 ; -4,6 ; 8,8 ; 9,6 ; -0,27 ; NABBTCMA1992 ; 3de0C8effB82FDA0C82bdA1DaFACbEbc6dFA2CfE0B30dc0aECa1faaEbcCBBEBe ; < cSh8v72P9udt5dZ76W3d8kAMv7Nn3839453YM88TjTp20Jc4MxMiPH0josYI6tpL > >										2
2383 //	        < 3 ; 4M ; MAY 2019 ; opt. ; - ; 0 ; 0,0000441069576404218 ; -1 ; -0,00025 ; 0,00025 ; -3,2 ; -1,3 ; 3,4 ; -9,1 ; 1,3 ; -5 ; 0,12 ; NABBTCMA1979 ; 2Ce1cAaadb2dDDFd3Ac2c60aE3AbDDeBdfAEFCAe0f2DEacCDF2f68AfAaF87FDD ; < 5th40B7ZCgN9bgrtG1K59F0kNe8L8wu6S3ZZ8aOr8LdeNtae1xp2aUU0iRdWgSPF > >										3
2384 //	        < 4 ; 6M ; JUL 2019 ; opt. ; - ; 0 ; 0,0000441404630431867 ; -1 ; -0,00025 ; 0,00025 ; -1,7 ; -0,3 ; -9,1 ; -9,6 ; -9,7 ; -4,4 ; 0,35 ; NABBTCJU1923 ; CBCAB777BCa1fdB8feC8F2b149f2EBd122FeEF6c6A4dFCDA5186d6aA83D4FcEC ; < kcK5plndNfWa9T8h7w1T8RQU3A8Lvnyk94dV52UmZLLKQO2Hb2rXGM7oeN71rMIV > >										4
2385 //	        < 5 ; 8M ; SEP 2019 ; opt. ; - ; 0 ; 0,000044182260006002 ; -1 ; -0,00025 ; 0,00025 ; -1,6 ; -1,3 ; -3,9 ; -0,5 ; -1,8 ; 0,2 ; -0,11 ; NABBTCSE1981 ; de54D71b3ABddDFdd419b6aDAbFAFAAFb44E0c1cC4efAfbDE0A07a2fdd83ECE5 ; < 60w650tN8i4kMZcqS0I8pE58KuP9LTyJ926ld4HMnLQ9334324dp0Z5fBZJgHJ1J > >										5
2386 //	        < 6 ; 11M ; DEC 2019 ; opt. ; - ; 0 ; 0,0000442369673518382 ; -1 ; -0,00025 ; 0,00025 ; -7,9 ; 3,1 ; 7 ; -4,7 ; 9,1 ; -7 ; -0,31 ; NABBTCDE1963 ; 8AADCC6fac34B8A3f392Fa6e2bdFe53BffFB02a5eff7aEfCF28C1CcEFBDf1a9E ; < MuPk57l9t4796WGQ3fw1wyoSSQicn9xgyO3JFN869T0X7Y5cutpb4e5faGC4M3X6 > >										6
2387 //	        < 7 ; 12M ; JAN 2020 ; opt. ; - ; 0 ; 0,0000442991014761032 ; -1 ; -0,00025 ; 0,00025 ; -8,8 ; 3,4 ; -3,3 ; 6,6 ; 0 ; -8 ; -0,56 ; NABBTCJA2010 ; 7be6ad784be3e6832F45Df1a9a1DD7deb4fE5F6b2F87e6fAFCcE80DffCafBFb2 ; < 8m8T7SXEMyMH45qbt4wQXNOnAMzS195xa27GExbOn9Avw31f2vfieO23m73X824H > >										7
2388 //	        < 8 ; 14M ; MAR 2020 ; opt. ; - ; 0 ; 0,0000443709534222985 ; -1 ; -0,00025 ; 0,00025 ; 8,5 ; -8,7 ; -8,8 ; -3,6 ; 5,6 ; -6,6 ; -0,08 ; NABBTCMA2013 ; E99FE2fa5eD9B23EcdCEd6F7be27bD9cF0F45A89F7FFfF90cFDDDfcEAF28C314 ; < F7YggcN7i24PX615se6jZrCKKQYa2n9A0G9C66Qtu10znpn2K0Wa5276db44W6AM > >										8
2389 //	        < 9 ; 16M ; MAY 2020 ; opt. ; - ; 0 ; 0,0000444515938440585 ; -1 ; -0,00025 ; 0,00025 ; -0,7 ; -5,9 ; -4,8 ; -2,1 ; -3,6 ; -4,4 ; 0,23 ; NABBTCMA2017 ; CAaBedaa4d92b75BBb49dA5FB6BfFbEdDCD04a6Ce24c131caE2ABADfd7971ceA ; < 30NY4SvYUm4l7q7IJ577GA79wvpo7C589lx7ztoo89s0M36k8xnmTOXA7Uf1gP9M > >										9
2390 //	        < 10 ; 18M ; JUL 2020 ; opt. ; - ; 0 ; 0,0000445465379912128 ; -1 ; -0,00025 ; 0,00025 ; 5,4 ; -9,6 ; -0,6 ; 3,9 ; -3 ; -7,6 ; 0,28 ; NABBTCJU2027 ; F92B9Eb5533c9d3dF6f3A1aDfCbaB459290EBF0aD2ed0bFaED2cAf38519abAFa ; < p68YlL2YEJf8Rt0i487HC7f2u6aUh97PJy950pr6i4B6j87txZEYavl7ZknAj577 > >										10
2391 //	        < 11 ; 20M ; SEP 2020 ; opt. ; - ; 0 ; 0,0000446506623238387 ; -1 ; -0,00025 ; 0,00025 ; 5,6 ; -8,9 ; -4,2 ; -1,8 ; -7,2 ; -4,5 ; -0,35 ; NABBTCSE2032 ; 2dBA0abC6Ef1aBfeFdB0ca7e8d0eCdCed6a9Fc1df0ad9BfFe4aa1e3dba71e63B ; < L82d4d6grLq0nII9x663vIU84803ottc5Ok8jEfG5LVblp569EnN0JF13qu8R440 > >										11
2392 //	        < 12 ; 23M ; DEC 2020 ; opt. ; - ; 0 ; 0,0000447662182379327 ; -1 ; -0,00025 ; 0,00025 ; -1,2 ; 0,4 ; 3,6 ; 1,5 ; -4,5 ; -9 ; -0,02 ; NABBTCDE2063 ; eBBdBBFBecAf2FBCF8DbD8FfFfFDDa17BFFAB561bBD6Aaaf51fFA2Ffdf889FeB ; < Z950Io3KLgggH3L5Q1ZxD8GT4SQO75WRZ8Qm6QYeZn1LQ5xhG7c21fvwnz4VR1eZ > >										12
2393 //	        < 13 ; 24M ; JAN 2021 ; opt. ; - ; 0 ; 0,0000448885918541723 ; -1 ; -0,00025 ; 0,00025 ; 6,6 ; -2,3 ; 7,7 ; -6,4 ; -7,7 ; 8,3 ; 0,21 ; NABBTCJA2183 ; 0bf6CAB5b1DF5f1aDDEc13dcdFE9CAaD17547e1E16eCE7aC2173CDeC4FDaad0f ; < L9P1Uma4XO1Z06xB1TaK42cE74nV5uvBreJsQgG7lvH8prD2isrj12g39UgKkxyc > >										13
2394 //	        < 14 ; 26M ; MAR 2021 ; opt. ; - ; 0 ; 0,0000450218334890655 ; -1 ; -0,00025 ; 0,00025 ; -8,1 ; -2,5 ; -4,6 ; -7 ; -7,5 ; -8,8 ; 0,66 ; NABBTCMA2137 ; CC5157E8F3C50b86aFdAA5aCC0Df7D5bddEbEEd5A9cea925B7caAF4A9cc621a2 ; < ULOA6G2x7ertNPVC3K2oJJ83XbhN42zUuurglq9iZHCGk0WbjUvRjFM8c1qRNG67 > >										14
2395 //	        < 15 ; 28M ; MAY 2021 ; opt. ; - ; 0 ; 0,0000451594191295597 ; -1 ; -0,00025 ; 0,00025 ; -3,6 ; 6,5 ; 2,7 ; 2 ; 1,9 ; -5,9 ; 0,51 ; NABBTCMA2145 ; 1706ebd6374e8EA9CC5FA22C0dcc4aE5ffb1dc8B85Caa6e35e6E1Ac97530FB64 ; < vEXqioc3dV5J8WDhqpURFKeRU9jB2N8S9MGfxC65gXB0CVZ2f983Y8YW89vL2TpU > >										15
2396 //	        < 16 ; 30M ; JUL 2021 ; opt. ; - ; 0 ; 0,0000453065810974108 ; -1 ; -0,00025 ; 0,00025 ; 2,5 ; 6,8 ; -6,6 ; -8,5 ; 4,1 ; -3,2 ; -0,38 ; NABBTCJU2131 ; 1cb2eCCe33EA5aA505C62FB4336DD48cDAE5d7aCB7b6FfBb2CE5ce4f6dbe1C4A ; < 1cLt6PLEVqUO8j4X1n8HBdkfoZpFgO9C90bWt2JgzH1oOkwCnJI8g4nE9EN68l7B > >										16
2397 //	        < 17 ; 32M ; SEP 2021 ; opt. ; - ; 0 ; 0,0000454640445907012 ; -1 ; -0,00025 ; 0,00025 ; 4,9 ; 8,4 ; 7,7 ; -1,6 ; 7 ; 5,6 ; -0,78 ; NABBTCSE2168 ; eEeAeD3e0e8dEcfEAB647edCddeaccACfe1eFc94eabBEefddebcAfDD0eB15fA9 ; < KlZ47582B9Qpu3HpzW0cSQ435P6Ibl1u5An5Wc7DCQu19Xz6Q05T8I14HV71JzD8 > >										17
2398 //	        < 18 ; 35M ; DEC 2021 ; opt. ; - ; 0 ; 0,0000456336865249775 ; -1 ; -0,00025 ; 0,00025 ; -1,7 ; 2,4 ; 5,7 ; 1,5 ; -1,8 ; -1,5 ; 0,47 ; NABBTCDE2130 ; 054bdacC248cD6fEa7B5BAC5Dbc8ec3BCEA9cfaca90DFCCbc1EB269cCbDE52CD ; < 5p9750wg2Ca2cV1W3GSpIl9hTtit25C6Km90LrdML8uR1eSMs8uhtpP1M41wzr52 > >										18
2399 //	        < 19 ; 36M ; JAN 2021 ; opt. ; - ; 0 ; 0,0000458160487126199 ; -1 ; -0,00025 ; 0,00025 ; -4 ; 1,7 ; 6,8 ; -5,8 ; 8,3 ; -8,5 ; 0,97 ; NABBTCJA2187 ; dCBFdEc1BBDbEDbB0D9c5Ecd2cf1FF0A73A8a738cbeB9A3AECD2BDFeeEf8D4ed ; < xN5PBNWYB05KW3vjtxPxhuetNCJh06QU3c7jHs66wmFnx7cn1U29Oju248576ekO > >										19
2400 //	        < 20 ; 38M ; MAR 2021 ; opt. ; - ; 0 ; 0,0000460061916339643 ; -1 ; -0,00025 ; 0,00025 ; 6 ; 3,1 ; 2,5 ; -3,6 ; 3,2 ; -8,8 ; 0,66 ; NABBTCMA2183 ; f3FF9Ce1Baa1B8B3Ab0C5AD91A2acD9baCCeda9cCc5CE8A09BCAA0Cc2d0babb9 ; < 7N6FIu4PcbU3fS0c7714P99GWTTUekVpwx0y7bExIqyz2YPt5kqGleCMU8jilO1g > >										20
2401 //	        < 21 ; 40M ; MAY 2021 ; opt. ; - ; 0 ; 0,0000462048510026623 ; -1 ; -0,00025 ; 0,00025 ; -5,4 ; -9,5 ; -2,4 ; -9,3 ; 4,8 ; -5,7 ; -0,67 ; NABBTCMA2194 ; D73AeDBAAcfd5c4d13E3013cEb77E1BADE9A5EEABAFb725e1bd2A086D7c9FAec ; < T3CGjnj1PAw8I3zHHigwU4JmDbLj4huAgEg6X8tdY9g150XLmb8eSQ0kFRZK1ZgM > >										21
2402 //	        < 22 ; 42M ; JUL 2021 ; opt. ; - ; 0 ; 0,0000464156424757591 ; -1 ; -0,00025 ; 0,00025 ; -8,3 ; -9,3 ; 6,6 ; 7,8 ; 6,2 ; 1,9 ; 0,83 ; NABBTCJU2148 ; 05cb83C7Ebda3Ec9a169Afbcbbce4ECA9dFA3db9Dd5ae7EB98A95D5d3B7beA7B ; < 92XzHi6pOmin2n7rDxKYHYs34g94G2n4WCnV2RhQdUnuep46AJuW3TTq30d9R7Zf > >										22
2403 //	        < 23 ; 44M ; SEP 2021 ; opt. ; - ; 0 ; 0,0000466337568548027 ; -1 ; -0,00025 ; 0,00025 ; -3,1 ; 2,5 ; 3,3 ; -9,5 ; 8,5 ; -3,1 ; -0,43 ; NABBTCSE2145 ; cb5B5A4AB3F4a33baEEC7fEF03BEeBCCDACC46CFADb1dFCD19Bfdd7d2dEC51b2 ; < jCak5C37O1Mp1r6Uc7dIG67RiT0a081ULv8qXJvGdQI3tScl49l5SmozApsAf4Sw > >										23
2404 //	        < 24 ; 47M ; DEC 2021 ; opt. ; - ; 0 ; 0,000046867217100057 ; -1 ; -0,00025 ; 0,00025 ; 0,5 ; -6,5 ; -6,5 ; 0,7 ; 0,6 ; 2 ; -0,2 ; NABBTCDE2133 ; b1ecB1aCECfBFEFCaD556F5BE1DEaCf8EECDF3ABBAeEcB97cFFDBe68Db4De2aa ; < z5pbs7djdM6MTWuGDFuE6xPLeCpFJSq8V7lm67rsK722v587B5wq86L4G8Se9xyh > >										24
2405 											
2406 //	  < CALLS ; 24M ; Strike ; Symbol ; Last ; T(-1) ; Change ; Volume ; BAS_1 ; BAS_2 ; o.i. @ eth_hex ; @ btc_882 >										
2407 											
2408 //	#DIV/0 !										1
2409 //	#DIV/0 !										2
2410 //	#DIV/0 !										3
2411 //	#DIV/0 !										4
2412 //	#DIV/0 !										5
2413 //	#DIV/0 !										6
2414 //	#DIV/0 !										7
2415 //	#DIV/0 !										8
2416 //	#DIV/0 !										9
2417 //	#DIV/0 !										10
2418 //	#DIV/0 !										11
2419 //	#DIV/0 !										12
2420 //	#DIV/0 !										13
2421 //	#DIV/0 !										14
2422 //	#DIV/0 !										15
2423 //	#DIV/0 !										16
2424 //	#DIV/0 !										17
2425 //	#DIV/0 !										18
2426 //	#DIV/0 !										19
2427 //	#DIV/0 !										20
2428 //	#DIV/0 !										21
2429 //											
2430 //	  < PUTS ; 24M ; Strike ; Symbol ; Last ; T(-1) ; Change ; Volume ; BAS_1 ; BAS_2 ; o.i. @ eth_hex ; @ btc_882 >										
2431 //											
2432 //	#DIV/0 !										1
2433 //	#DIV/0 !										2
2434 //	#DIV/0 !										3
2435 //	#DIV/0 !										4
2436 //	#DIV/0 !										5
2437 //	#DIV/0 !										6
2438 //	#DIV/0 !										7
2439 //	#DIV/0 !										8
2440 //	#DIV/0 !										9
2441 //	#DIV/0 !										10
2442 //	#DIV/0 !										11
2443 //	#DIV/0 !										12
2444 //	#DIV/0 !										13
2445 //	#DIV/0 !										14
2446 //	#DIV/0 !										15
2447 //	#DIV/0 !										16
2448 //	#DIV/0 !										17
2449 //	#DIV/0 !										18
2450 //	#DIV/0 !										19
2451 //	#DIV/0 !										20
2452 //	#DIV/0 !										21
2453 											
2454 											
2455 											
2456 											
2457 											
2458 //	NABBTC										
2459 											
2460 //	  < # ; REF ; Month ; Optionchain ; Chart ; Last ; T(-1) ; Change ; BAS_1 ; BAS_2 ; Prior. Settle ; Open ; High ; Low ; Volume ; Hi / Lo ; Updated (s) ; Code ; @ eth_hex ; @ btc_882 >										
2461 											
2462 //	        < 0 ; T0 ; - ; - ; - ; 0 ; 0,0000440550542260437 ; -1 ; - ; - ; - ; - ; - ; - ; - ; - ; - ; - ; EE23C8F0AAB2FCCcf514Fe30bE8D5f28bFA9c3bfDccc90FC8e6ABFc6a99fa4b4 ; < S8iBCc8103aaUo44672xd5w60P1I82Kuz5Ih2hZmf50A48N8P6di4n3vmBft11YC > >										0
2463 //	        < 1 ; 0M ; JAN 2019 ; opt. ; - ; 0 ; 0,0000440625918254867 ; -1 ; -0,00025 ; 0,00025 ; -2,2 ; -8 ; 5,7 ; -9,2 ; -2,8 ; 6,6 ; -0,15 ; NABBTC19JA19 ; 87d0EDf5AFEa1Ae2e9aD5d8badA7DDcfBBEcF0460D2C6dDD78f8D7d7AaCdc91d ; < UjRh45OBMC0s7B9qB4HjYPlX08TQKhsYl369SzY5X456PMH32j8DP8TeR4Uuw8XU > >										1
2464 //	        < 2 ; 2M ; MAR 2019 ; opt. ; - ; 0 ; 0,0000440785527635661 ; -1 ; -0,00025 ; 0,00025 ; 6,8 ; -6,1 ; 3,1 ; -4,6 ; 8,8 ; 9,6 ; -0,27 ; NABBTCMA1992 ; 3de0C8effB82FDA0C82bdA1DaFACbEbc6dFA2CfE0B30dc0aECa1faaEbcCBBEBe ; < cSh8v72P9udt5dZ76W3d8kAMv7Nn3839453YM88TjTp20Jc4MxMiPH0josYI6tpL > >										2
2465 //	        < 3 ; 4M ; MAY 2019 ; opt. ; - ; 0 ; 0,0000441069576404218 ; -1 ; -0,00025 ; 0,00025 ; -3,2 ; -1,3 ; 3,4 ; -9,1 ; 1,3 ; -5 ; 0,12 ; NABBTCMA1979 ; 2Ce1cAaadb2dDDFd3Ac2c60aE3AbDDeBdfAEFCAe0f2DEacCDF2f68AfAaF87FDD ; < 5th40B7ZCgN9bgrtG1K59F0kNe8L8wu6S3ZZ8aOr8LdeNtae1xp2aUU0iRdWgSPF > >										3
2466 //	        < 4 ; 6M ; JUL 2019 ; opt. ; - ; 0 ; 0,0000441404630431867 ; -1 ; -0,00025 ; 0,00025 ; -1,7 ; -0,3 ; -9,1 ; -9,6 ; -9,7 ; -4,4 ; 0,35 ; NABBTCJU1923 ; CBCAB777BCa1fdB8feC8F2b149f2EBd122FeEF6c6A4dFCDA5186d6aA83D4FcEC ; < kcK5plndNfWa9T8h7w1T8RQU3A8Lvnyk94dV52UmZLLKQO2Hb2rXGM7oeN71rMIV > >										4
2467 //	        < 5 ; 8M ; SEP 2019 ; opt. ; - ; 0 ; 0,000044182260006002 ; -1 ; -0,00025 ; 0,00025 ; -1,6 ; -1,3 ; -3,9 ; -0,5 ; -1,8 ; 0,2 ; -0,11 ; NABBTCSE1981 ; de54D71b3ABddDFdd419b6aDAbFAFAAFb44E0c1cC4efAfbDE0A07a2fdd83ECE5 ; < 60w650tN8i4kMZcqS0I8pE58KuP9LTyJ926ld4HMnLQ9334324dp0Z5fBZJgHJ1J > >										5
2468 //	        < 6 ; 11M ; DEC 2019 ; opt. ; - ; 0 ; 0,0000442369673518382 ; -1 ; -0,00025 ; 0,00025 ; -7,9 ; 3,1 ; 7 ; -4,7 ; 9,1 ; -7 ; -0,31 ; NABBTCDE1963 ; 8AADCC6fac34B8A3f392Fa6e2bdFe53BffFB02a5eff7aEfCF28C1CcEFBDf1a9E ; < MuPk57l9t4796WGQ3fw1wyoSSQicn9xgyO3JFN869T0X7Y5cutpb4e5faGC4M3X6 > >										6
2469 //	        < 7 ; 12M ; JAN 2020 ; opt. ; - ; 0 ; 0,0000442991014761032 ; -1 ; -0,00025 ; 0,00025 ; -8,8 ; 3,4 ; -3,3 ; 6,6 ; 0 ; -8 ; -0,56 ; NABBTCJA2010 ; 7be6ad784be3e6832F45Df1a9a1DD7deb4fE5F6b2F87e6fAFCcE80DffCafBFb2 ; < 8m8T7SXEMyMH45qbt4wQXNOnAMzS195xa27GExbOn9Avw31f2vfieO23m73X824H > >										7
2470 //	        < 8 ; 14M ; MAR 2020 ; opt. ; - ; 0 ; 0,0000443709534222985 ; -1 ; -0,00025 ; 0,00025 ; 8,5 ; -8,7 ; -8,8 ; -3,6 ; 5,6 ; -6,6 ; -0,08 ; NABBTCMA2013 ; E99FE2fa5eD9B23EcdCEd6F7be27bD9cF0F45A89F7FFfF90cFDDDfcEAF28C314 ; < F7YggcN7i24PX615se6jZrCKKQYa2n9A0G9C66Qtu10znpn2K0Wa5276db44W6AM > >										8
2471 //	        < 9 ; 16M ; MAY 2020 ; opt. ; - ; 0 ; 0,0000444515938440585 ; -1 ; -0,00025 ; 0,00025 ; -0,7 ; -5,9 ; -4,8 ; -2,1 ; -3,6 ; -4,4 ; 0,23 ; NABBTCMA2017 ; CAaBedaa4d92b75BBb49dA5FB6BfFbEdDCD04a6Ce24c131caE2ABADfd7971ceA ; < 30NY4SvYUm4l7q7IJ577GA79wvpo7C589lx7ztoo89s0M36k8xnmTOXA7Uf1gP9M > >										9
2472 //	        < 10 ; 18M ; JUL 2020 ; opt. ; - ; 0 ; 0,0000445465379912128 ; -1 ; -0,00025 ; 0,00025 ; 5,4 ; -9,6 ; -0,6 ; 3,9 ; -3 ; -7,6 ; 0,28 ; NABBTCJU2027 ; F92B9Eb5533c9d3dF6f3A1aDfCbaB459290EBF0aD2ed0bFaED2cAf38519abAFa ; < p68YlL2YEJf8Rt0i487HC7f2u6aUh97PJy950pr6i4B6j87txZEYavl7ZknAj577 > >										10
2473 //	        < 11 ; 20M ; SEP 2020 ; opt. ; - ; 0 ; 0,0000446506623238387 ; -1 ; -0,00025 ; 0,00025 ; 5,6 ; -8,9 ; -4,2 ; -1,8 ; -7,2 ; -4,5 ; -0,35 ; NABBTCSE2032 ; 2dBA0abC6Ef1aBfeFdB0ca7e8d0eCdCed6a9Fc1df0ad9BfFe4aa1e3dba71e63B ; < L82d4d6grLq0nII9x663vIU84803ottc5Ok8jEfG5LVblp569EnN0JF13qu8R440 > >										11
2474 //	        < 12 ; 23M ; DEC 2020 ; opt. ; - ; 0 ; 0,0000447662182379327 ; -1 ; -0,00025 ; 0,00025 ; -1,2 ; 0,4 ; 3,6 ; 1,5 ; -4,5 ; -9 ; -0,02 ; NABBTCDE2063 ; eBBdBBFBecAf2FBCF8DbD8FfFfFDDa17BFFAB561bBD6Aaaf51fFA2Ffdf889FeB ; < Z950Io3KLgggH3L5Q1ZxD8GT4SQO75WRZ8Qm6QYeZn1LQ5xhG7c21fvwnz4VR1eZ > >										12
2475 //	        < 13 ; 24M ; JAN 2021 ; opt. ; - ; 0 ; 0,0000448885918541723 ; -1 ; -0,00025 ; 0,00025 ; 6,6 ; -2,3 ; 7,7 ; -6,4 ; -7,7 ; 8,3 ; 0,21 ; NABBTCJA2183 ; 0bf6CAB5b1DF5f1aDDEc13dcdFE9CAaD17547e1E16eCE7aC2173CDeC4FDaad0f ; < L9P1Uma4XO1Z06xB1TaK42cE74nV5uvBreJsQgG7lvH8prD2isrj12g39UgKkxyc > >										13
2476 //	        < 14 ; 26M ; MAR 2021 ; opt. ; - ; 0 ; 0,0000450218334890655 ; -1 ; -0,00025 ; 0,00025 ; -8,1 ; -2,5 ; -4,6 ; -7 ; -7,5 ; -8,8 ; 0,66 ; NABBTCMA2137 ; CC5157E8F3C50b86aFdAA5aCC0Df7D5bddEbEEd5A9cea925B7caAF4A9cc621a2 ; < ULOA6G2x7ertNPVC3K2oJJ83XbhN42zUuurglq9iZHCGk0WbjUvRjFM8c1qRNG67 > >										14
2477 //	        < 15 ; 28M ; MAY 2021 ; opt. ; - ; 0 ; 0,0000451594191295597 ; -1 ; -0,00025 ; 0,00025 ; -3,6 ; 6,5 ; 2,7 ; 2 ; 1,9 ; -5,9 ; 0,51 ; NABBTCMA2145 ; 1706ebd6374e8EA9CC5FA22C0dcc4aE5ffb1dc8B85Caa6e35e6E1Ac97530FB64 ; < vEXqioc3dV5J8WDhqpURFKeRU9jB2N8S9MGfxC65gXB0CVZ2f983Y8YW89vL2TpU > >										15
2478 //	        < 16 ; 30M ; JUL 2021 ; opt. ; - ; 0 ; 0,0000453065810974108 ; -1 ; -0,00025 ; 0,00025 ; 2,5 ; 6,8 ; -6,6 ; -8,5 ; 4,1 ; -3,2 ; -0,38 ; NABBTCJU2131 ; 1cb2eCCe33EA5aA505C62FB4336DD48cDAE5d7aCB7b6FfBb2CE5ce4f6dbe1C4A ; < 1cLt6PLEVqUO8j4X1n8HBdkfoZpFgO9C90bWt2JgzH1oOkwCnJI8g4nE9EN68l7B > >										16
2479 //	        < 17 ; 32M ; SEP 2021 ; opt. ; - ; 0 ; 0,0000454640445907012 ; -1 ; -0,00025 ; 0,00025 ; 4,9 ; 8,4 ; 7,7 ; -1,6 ; 7 ; 5,6 ; -0,78 ; NABBTCSE2168 ; eEeAeD3e0e8dEcfEAB647edCddeaccACfe1eFc94eabBEefddebcAfDD0eB15fA9 ; < KlZ47582B9Qpu3HpzW0cSQ435P6Ibl1u5An5Wc7DCQu19Xz6Q05T8I14HV71JzD8 > >										17
2480 //	        < 18 ; 35M ; DEC 2021 ; opt. ; - ; 0 ; 0,0000456336865249775 ; -1 ; -0,00025 ; 0,00025 ; -1,7 ; 2,4 ; 5,7 ; 1,5 ; -1,8 ; -1,5 ; 0,47 ; NABBTCDE2130 ; 054bdacC248cD6fEa7B5BAC5Dbc8ec3BCEA9cfaca90DFCCbc1EB269cCbDE52CD ; < 5p9750wg2Ca2cV1W3GSpIl9hTtit25C6Km90LrdML8uR1eSMs8uhtpP1M41wzr52 > >										18
2481 //	        < 19 ; 36M ; JAN 2021 ; opt. ; - ; 0 ; 0,0000458160487126199 ; -1 ; -0,00025 ; 0,00025 ; -4 ; 1,7 ; 6,8 ; -5,8 ; 8,3 ; -8,5 ; 0,97 ; NABBTCJA2187 ; dCBFdEc1BBDbEDbB0D9c5Ecd2cf1FF0A73A8a738cbeB9A3AECD2BDFeeEf8D4ed ; < xN5PBNWYB05KW3vjtxPxhuetNCJh06QU3c7jHs66wmFnx7cn1U29Oju248576ekO > >										19
2482 //	        < 20 ; 38M ; MAR 2021 ; opt. ; - ; 0 ; 0,0000460061916339643 ; -1 ; -0,00025 ; 0,00025 ; 6 ; 3,1 ; 2,5 ; -3,6 ; 3,2 ; -8,8 ; 0,66 ; NABBTCMA2183 ; f3FF9Ce1Baa1B8B3Ab0C5AD91A2acD9baCCeda9cCc5CE8A09BCAA0Cc2d0babb9 ; < 7N6FIu4PcbU3fS0c7714P99GWTTUekVpwx0y7bExIqyz2YPt5kqGleCMU8jilO1g > >										20
2483 //	        < 21 ; 40M ; MAY 2021 ; opt. ; - ; 0 ; 0,0000462048510026623 ; -1 ; -0,00025 ; 0,00025 ; -5,4 ; -9,5 ; -2,4 ; -9,3 ; 4,8 ; -5,7 ; -0,67 ; NABBTCMA2194 ; D73AeDBAAcfd5c4d13E3013cEb77E1BADE9A5EEABAFb725e1bd2A086D7c9FAec ; < T3CGjnj1PAw8I3zHHigwU4JmDbLj4huAgEg6X8tdY9g150XLmb8eSQ0kFRZK1ZgM > >										21
2484 //	        < 22 ; 42M ; JUL 2021 ; opt. ; - ; 0 ; 0,0000464156424757591 ; -1 ; -0,00025 ; 0,00025 ; -8,3 ; -9,3 ; 6,6 ; 7,8 ; 6,2 ; 1,9 ; 0,83 ; NABBTCJU2148 ; 05cb83C7Ebda3Ec9a169Afbcbbce4ECA9dFA3db9Dd5ae7EB98A95D5d3B7beA7B ; < 92XzHi6pOmin2n7rDxKYHYs34g94G2n4WCnV2RhQdUnuep46AJuW3TTq30d9R7Zf > >										22
2485 //	        < 23 ; 44M ; SEP 2021 ; opt. ; - ; 0 ; 0,0000466337568548027 ; -1 ; -0,00025 ; 0,00025 ; -3,1 ; 2,5 ; 3,3 ; -9,5 ; 8,5 ; -3,1 ; -0,43 ; NABBTCSE2145 ; cb5B5A4AB3F4a33baEEC7fEF03BEeBCCDACC46CFADb1dFCD19Bfdd7d2dEC51b2 ; < jCak5C37O1Mp1r6Uc7dIG67RiT0a081ULv8qXJvGdQI3tScl49l5SmozApsAf4Sw > >										23
2486 //	        < 24 ; 47M ; DEC 2021 ; opt. ; - ; 0 ; 0,000046867217100057 ; -1 ; -0,00025 ; 0,00025 ; 0,5 ; -6,5 ; -6,5 ; 0,7 ; 0,6 ; 2 ; -0,2 ; NABBTCDE2133 ; b1ecB1aCECfBFEFCaD556F5BE1DEaCf8EECDF3ABBAeEcB97cFFDBe68Db4De2aa ; < z5pbs7djdM6MTWuGDFuE6xPLeCpFJSq8V7lm67rsK722v587B5wq86L4G8Se9xyh > >										24
2487 											
2488 //	  < CALLS ; 36M ; Strike ; Symbol ; Last ; T(-1) ; Change ; Volume ; BAS_1 ; BAS_2 ; o.i. @ eth_hex ; @ btc_882 >										
2489 											
2490 //	#DIV/0 !										1
2491 //	#DIV/0 !										2
2492 //	#DIV/0 !										3
2493 //	#DIV/0 !										4
2494 //	#DIV/0 !										5
2495 //	#DIV/0 !										6
2496 //	#DIV/0 !										7
2497 //	#DIV/0 !										8
2498 //	#DIV/0 !										9
2499 //	#DIV/0 !										10
2500 //	#DIV/0 !										11
2501 //	#DIV/0 !										12
2502 //	#DIV/0 !										13
2503 //	#DIV/0 !										14
2504 //	#DIV/0 !										15
2505 //	#DIV/0 !										16
2506 //	#DIV/0 !										17
2507 //	#DIV/0 !										18
2508 //	#DIV/0 !										19
2509 //	#DIV/0 !										20
2510 //	#DIV/0 !										21
2511 //											
2512 //	  < PUTS ; 36M ; Strike ; Symbol ; Last ; T(-1) ; Change ; Volume ; BAS_1 ; BAS_2 ; o.i. @ eth_hex ; @ btc_882 >										
2513 //											
2514 //	#DIV/0 !										1
2515 //	#DIV/0 !										2
2516 //	#DIV/0 !										3
2517 //	#DIV/0 !										4
2518 //	#DIV/0 !										5
2519 //	#DIV/0 !										6
2520 //	#DIV/0 !										7
2521 //	#DIV/0 !										8
2522 //	#DIV/0 !										9
2523 //	#DIV/0 !										10
2524 //	#DIV/0 !										11
2525 //	#DIV/0 !										12
2526 //	#DIV/0 !										13
2527 //	#DIV/0 !										14
2528 //	#DIV/0 !										15
2529 //	#DIV/0 !										16
2530 //	#DIV/0 !										17
2531 //	#DIV/0 !										18
2532 //	#DIV/0 !										19
2533 //	#DIV/0 !										20
2534 //	#DIV/0 !										21
2535 											
2536 											
2537 											
2538 											
2539 	}