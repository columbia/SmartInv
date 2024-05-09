1 pragma solidity ^0.4.2;
2 contract storer {
3 	address public owner;
4 	string public log;
5 
6 	function storer() {
7 		owner = msg.sender ;
8 		}
9 
10 	modifier onlyOwner {
11 		if (msg.sender != owner)
12             		throw;
13         		_;
14 		}
15 
16 	function store(string _log) onlyOwner() {
17 	log = _log;
18 		}
19 
20 	function kill() onlyOwner() {
21 	selfdestruct(owner); }
22 	
23 /*
24 
25 {
26 	"maker": {
27 		"address": "0x0a6d88d0ac14bb76b58bf6341b65a10353b8aee8",
28 		"token": {
29 			"name": "Augur Reputation Token",
30 			"symbol": "REP",
31 			"decimals": 18,
32 			"address": "0xe94327d07fc17907b4db788e5adf2ed424addff6"
33 		},
34 		"amount": "860000000000000000",
35 		"feeAmount": "0"
36 	},
37 	"taker": {
38 		"address": "0x6CF821A13455cABed0adc2789C6803FA2e938cA9",
39 		"token": {
40 			"name": "pcp cab dac sec 5",
41 			"symbol": "CCA",
42 			"decimals": 8,
43 			"address": "0xaf34de25a4962c05287025a386869fa0e12ce95d"
44 		},
45 		"amount": "1700000000",
46 		"feeAmount": "0"
47 	},
48 	"expiration": "1509303780",
49 	"feeRecipient": "0x0000000000000000000000000000000000000000",
50 	"salt": "99080185595902305128011107182726626379042477463436851204612997193034843428216",
51 	"signature": {
52 		"v": 28,
53 		"r": "0xa5a3b9dee57e814e2cc733c2b362cee5c037baade9dbdd47bcfa47de10c38a10",
54 		"s": "0x75225fddc9b382a218b4d64e8992ab17e6d030fde885c4c618a97da0311e1e5f",
55 		"hash": "0x4e427f1a75e0f55745689b0f6e36d4f44a8fcb1b525620c69e491a36daf9a3ee"
56 	},
57 	"exchangeContract": "0x12459c951127e0c374ff9105dda097662a027093",
58 	"networkId": 1
59 }
60 
61 	'0x protocol implementation
62 	'carnet d'ordres
63 	'offre d'achat
64 	'acheteur, compte numéro :	0x0a6d88d0ac14bb76b58bf6341b65a10353b8aee8
65 	'compte d'actif, actif :	CCA (clevestAB equity)
66 	'volume :			17.00000000
67 	'au prix de
68 	'compte en devises, devise :	REP
69 	'montant :			0.860
70 	'consolidation
71 	'compte en devises, devise :	ETH
72 	'montant :			0.01
73 	'compte en devise, devise :	CHF
74 	'montant :			17.00
75 	'contrôle source :		
76 
77 */	
78 }