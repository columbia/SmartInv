1 pragma solidity ^0.4.11;
2 
3 contract SafeMath {
4     function safeAdd(uint256 x, uint256 y) internal returns(uint256) {
5       uint256 z = x + y;
6       assert((z >= x) && (z >= y));
7       return z;
8     }
9 
10     function safeSubtract(uint256 x, uint256 y) internal returns(uint256) {
11       assert(x >= y);
12       uint256 z = x - y;
13       return z;
14     }
15 
16     function safeMult(uint256 x, uint256 y) internal returns(uint256) {
17       uint256 z = x * y;
18       assert((x == 0)||(z/x == y));
19       return z;
20     }
21 }
22 
23 
24 contract IndorsePreSale is SafeMath{
25     // Fund deposit address
26     address public ethFundDeposit = "0x1c82ee5b828455F870eb2998f2c9b6Cc2d52a5F6";                              
27     address public owner;                                       // Owner of the pre sale contract
28     mapping (address => uint256) public whiteList;
29 
30     // presale parameters
31     bool public isFinalized;                                    // switched to true in operational state
32     uint256 public constant maxLimit =  14000 ether;            // Maximum limit for taking in the money
33     uint256 public constant minRequired = 100 ether;            // Minimum contribution per person
34     uint256 public totalSupply;
35     mapping (address => uint256) public balances;
36     
37     // events
38     event Contribution(address indexed _to, uint256 _value);
39     
40     modifier onlyOwner() {
41       require (msg.sender == owner);
42       _;
43     }
44 
45     // @dev constructor
46     function IndorsePreSale() {
47       isFinalized = false;                                      //controls pre through crowdsale state
48       owner = msg.sender;
49       totalSupply = 0;
50     }
51 
52     // @dev this function accepts Ether and increases the balances of the contributors
53     function() payable {           
54       uint256 checkedSupply = safeAdd(totalSupply, msg.value);
55       require (msg.value >= minRequired);                        // The contribution needs to be above 100 Ether
56       require (!isFinalized);                                    // Cannot accept Ether after finalizing the contract
57       require (checkedSupply <= maxLimit);
58       require (whiteList[msg.sender] == 1);
59       balances[msg.sender] = safeAdd(balances[msg.sender], msg.value);
60       
61       totalSupply = safeAdd(totalSupply, msg.value);
62       Contribution(msg.sender, msg.value);
63       ethFundDeposit.transfer(this.balance);                     // send the eth to Indorse multi-sig
64     }
65     
66     // @dev adds an Ethereum address to whitelist
67     function setWhiteList(address _whitelisted) onlyOwner {
68       whiteList[_whitelisted] = 1;
69     }
70 
71     // @dev removed an Ethereum address from whitelist
72     function removeWhiteList(address _whitelisted) onlyOwner {
73       whiteList[_whitelisted] = 0;
74     }
75 
76     /// @dev Ends the funding period and sends the ETH home
77     function finalize() external onlyOwner {
78       require (!isFinalized);
79       // move to operational
80       isFinalized = true;
81       ethFundDeposit.transfer(this.balance);                     // send the eth to Indorse multi-sig
82     }
83 }