1 pragma solidity 0.4.25;
2 
3 
4 
5 
6 
7 
8 
9 
10 
11 
12 
13 
14 
15 
16 
17 contract	InitAtomicSwap  {
18     
19     //Initiations store information about users first init
20     struct Initiations {
21         address addressFrom;
22         address addressTo;
23         bool isShow;
24         bool isInit;
25         uint blockTimestamp;
26         uint amount;
27         bytes32 hashSecret;
28     }
29     
30     //ConfirmedInitiations - struct for storing information 
31     //about order that was already paid 
32     struct ConfirmedInitiations {
33         address addressFrom;
34         address addressTo;
35         bool isShow;
36         bool isRedeem;
37         bool isInit;
38         uint blockTimestamp;
39         uint amount;
40         bytes32 hashSecret;
41     }
42 
43     mapping(address=>Initiations) public inits;
44     
45     mapping(address=>mapping(bytes32=>ConfirmedInitiations)) public confirmedInits;
46     
47     modifier isInitCreated(address _addressOfInitiator) {
48 	    require(inits[_addressOfInitiator].isInit == false);
49 	    _;
50 	}
51 	
52 	modifier isValidHashsecret(string _password, address _addressOfInitiator) {
53 	    require(inits[_addressOfInitiator].hashSecret == keccak256(abi.encodePacked(
54 	        inits[_addressOfInitiator].addressFrom,
55 	        inits[_addressOfInitiator].addressTo,
56 	        inits[_addressOfInitiator].amount,
57 	        inits[_addressOfInitiator].blockTimestamp,
58 	        _password)));
59 	    _;
60 	}
61 	
62 	modifier isTxValid(address _addressOfInitiator, uint _blockTimestamp) {
63 	    require(inits[_addressOfInitiator].blockTimestamp >= _blockTimestamp);
64 	    _;
65 	}
66     
67     //addInit - this function will write data of order to mapping inits in Initiations struct with address of the sender key 
68     function addInit(address _addressFrom, address _addressTo, uint _amount, string _password) public 
69     returns(bytes32) {
70         
71         if(inits[_addressFrom].isInit == true) {
72             return 0;
73         }
74         inits[_addressFrom].addressFrom = _addressFrom;
75         inits[_addressFrom].addressTo = _addressTo;
76         inits[_addressFrom].isShow = false;
77         inits[_addressFrom].isInit = true;
78         inits[_addressFrom].blockTimestamp = now;
79         inits[_addressFrom].amount = _amount;
80         
81         inits[_addressFrom].hashSecret = keccak256(abi.encodePacked(
82             _addressFrom, 
83             _addressTo, 
84             _amount, 
85             inits[_addressFrom].blockTimestamp, 
86             _password));
87         
88         return inits[_addressFrom].hashSecret;
89 	}
90 	
91 	//getInit - this function returns data about order of the special address
92 	function getInit(address _addressOfInitiator) public view returns(address, address, uint, uint, bytes32) {
93 	    return (
94 	        inits[_addressOfInitiator].addressFrom, 
95 	        inits[_addressOfInitiator].addressTo, 
96 	        inits[_addressOfInitiator].amount,
97 	        inits[_addressOfInitiator].blockTimestamp,
98 	        inits[_addressOfInitiator].hashSecret
99 	        );
100 	}
101 	
102 	//confirmInit function that write information about already sended tx
103 	function confirmInit(address _addressOfInitiator, string _password, bytes32 _txHash, uint _blockTimestamp) public 
104 	isValidHashsecret(_password, _addressOfInitiator) 
105 	isTxValid(_addressOfInitiator, _blockTimestamp) 
106 	returns(bool) {
107 	    confirmedInits[_addressOfInitiator][_txHash].addressFrom = inits[_addressOfInitiator].addressFrom;
108 	    confirmedInits[_addressOfInitiator][_txHash].addressTo = inits[_addressOfInitiator].addressTo;
109 	    confirmedInits[_addressOfInitiator][_txHash].isShow = inits[_addressOfInitiator].isShow;
110 	    confirmedInits[_addressOfInitiator][_txHash].isInit = inits[_addressOfInitiator].isInit;
111 	    confirmedInits[_addressOfInitiator][_txHash].amount = inits[_addressOfInitiator].amount;
112 	    confirmedInits[_addressOfInitiator][_txHash].blockTimestamp = inits[_addressOfInitiator].blockTimestamp;
113 	    confirmedInits[_addressOfInitiator][_txHash].hashSecret = inits[_addressOfInitiator].hashSecret;
114 	    
115 	    delete(inits[_addressOfInitiator]);
116 	    
117 	    return true;
118 	}
119 }