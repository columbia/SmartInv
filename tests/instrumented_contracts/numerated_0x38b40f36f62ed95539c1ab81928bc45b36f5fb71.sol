1 pragma solidity ^0.4.18;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that throw on error
6  */
7 library SafeMath {
8   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
9     if (a == 0) {
10       return 0;
11     }
12     uint256 c = a * b;
13     assert(c / a == b);
14     return c;
15   }
16 
17   function div(uint256 a, uint256 b) internal pure returns (uint256) {
18     // assert(b > 0); // Solidity automatically throws when dividing by 0
19     uint256 c = a / b;
20     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
21     return c;
22   }
23 
24   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
25     assert(b <= a);
26     return a - b;
27   }
28 
29   function add(uint256 a, uint256 b) internal pure returns (uint256) {
30     uint256 c = a + b;
31     assert(c >= a);
32     return c;
33   }
34 }
35 
36 contract Ownable {
37     
38   address public owner;
39 
40   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
41 
42   constructor() public {
43     owner = msg.sender;
44   }
45 
46   modifier onlyOwner() {
47     require(msg.sender == owner);
48     _;
49   }
50 
51   function transferOwnership(address newOwner) public onlyOwner {
52     require(newOwner != address(0));
53     emit OwnershipTransferred(owner, newOwner);
54     owner = newOwner;
55   }
56 
57 }
58 
59 contract MintTokensInterface {
60     
61    function mintTokensExternal(address to, uint tokens) public;
62     
63 }
64 
65 contract TokenDistributor is Ownable {
66 
67   using SafeMath for uint256;
68 
69   bool public stopContract = false;
70     
71   MintTokensInterface public crowdsale = MintTokensInterface(0x8DD9034f7cCC805bDc4D593A01f6A2E2EB94A67a);
72   
73   mapping(address => bool) public authorized;
74 
75   mapping(address => uint) public balances;
76 
77   address[] public rewardHolders;
78 
79   event RewardTransfer(address indexed to, uint amount);
80 
81   modifier onlyAuthorized() {
82     require(msg.sender == owner || authorized[msg.sender]);
83     _;
84   }
85   
86   function setStopContract(bool newStopContract) public onlyOwner {
87     stopContract = newStopContract;
88   }
89   
90   function addAuthorized(address to) public onlyOwner {
91     authorized[to] = true;
92   }
93   
94   function removeAuthorized(address to) public onlyOwner {
95     authorized[to] = false;
96   }
97     
98   function mintBatch(address[] wallets, uint[] tokens) public onlyOwner {
99     for(uint i=0; i<wallets.length; i++) crowdsale.mintTokensExternal(wallets[i], tokens[i]);
100   }
101 
102   function mintAuthorizedBatch(address[] wallets, uint[] tokens) public onlyAuthorized {
103     for(uint i=0; i<wallets.length; i++) crowdsale.mintTokensExternal(wallets[i], tokens[i]);
104   }
105 
106   function isContract(address addr) public view returns(bool) {
107     uint codeLength;
108     assembly {
109       // Retrieve the size of the code on target address, this needs assembly .
110       codeLength := extcodesize(addr)
111     }
112     return codeLength > 0;
113   }
114   
115   function mintAuthorizedBatchWithBalances(address[] wallets, uint[] tokens) public onlyAuthorized {
116     address wallet;
117     uint reward;
118     bool isItContract;
119     for(uint i=0; i<wallets.length; i++) {
120       wallet = wallets[i];
121       isItContract = isContract(wallet);
122       if(!isItContract || (isItContract && !stopContract)) {
123         reward = tokens[i];
124         crowdsale.mintTokensExternal(wallet, reward);
125         if(balances[wallet] == 0) {
126           rewardHolders.push(wallet);
127         }
128         balances[wallet] = balances[wallet].add(reward);
129         emit RewardTransfer(wallet, reward);
130       }
131     }
132   }
133     
134 }