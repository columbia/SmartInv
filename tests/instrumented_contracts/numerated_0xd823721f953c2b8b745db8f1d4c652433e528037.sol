1 /**
2  *Submitted for verification at Etherscan.io on 2019-05-08
3 */
4 
5 pragma solidity ^0.5.10;
6 
7 /**
8  * @title Ownable
9  * @dev The Ownable contract has an owner address, and provides basic authorization control
10  * functions, this simplifies the implementation of "user permissions".
11  */
12 contract Ownable {
13     address public owner;
14 
15 
16     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
17 
18 
19     /**
20      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
21      * account.
22      */
23     constructor() public {
24         owner = msg.sender;
25     }
26 
27     /**
28      * @dev Throws if called by any account other than the owner.
29      */
30     modifier onlyOwner() {
31         require(msg.sender == owner);
32         _;
33     }
34 
35     /**
36      * @dev Allows the current owner to transfer control of the contract to a newOwner.
37      * @param newOwner The address to transfer ownership to.
38      */
39     function transferOwnership(address newOwner) public onlyOwner {
40         require(newOwner != address(0));
41         emit OwnershipTransferred(owner, newOwner);
42         owner = newOwner;
43     }
44 
45 }
46 
47 
48 /**
49  * @title ERC20Basic
50  * @dev Simpler version of ERC20 interface
51  * @dev see https://github.com/ethereum/EIPs/issues/179
52  */
53 contract ERC20BasicInterface {
54     function totalSupply() public view returns (uint256);
55 
56     function balanceOf(address who) public view returns (uint256);
57 
58     function transfer(address to, uint256 value) public returns (bool);
59 
60     function transferFrom(address from, address to, uint256 value) public returns (bool);
61 
62     event Transfer(address indexed from, address indexed to, uint256 value);
63 
64     uint8 public decimals;
65 }
66 
67 contract Bussiness is Ownable {
68     address payable public ceoAddress = address(0x2BebE5B81844151212DE3c7ea2e2C07616f7801B);
69     address public technical = address(0x2076A228E6eB670fd1C604DE574d555476520DB7);
70     ERC20BasicInterface public nagemonToken = ERC20BasicInterface(0xF63C5639786E7ce7C35B3D2b97E74bf7af63eEEA);
71     uint256 public NagemonExchange = 297;
72     constructor() public {}
73     
74     /**
75      * @dev Throws if called by any account other than the ceo address.
76      */
77     modifier onlyCeoAddress() {
78         require(msg.sender == ceoAddress);
79         _;
80     }
81     modifier onlyTechnicalAddress() {
82         require(msg.sender == technical);
83         _;
84     }
85     event received(address _from, uint256 _amount);
86     event receivedErc20(address _from, uint256 _amount);
87     struct ticket {
88         address owner;
89         uint256 amount;
90     }
91     mapping(address => ticket) public tickets;
92     // @dev fallback function to exchange the ether for Monster fossil
93     function buyMonsterFossilByEth() public payable {
94         ceoAddress.transfer(msg.value);
95         // calc token amount
96         uint256 amount = getTokenAmount(msg.value);
97         tickets[msg.sender] = ticket(msg.sender, amount);
98         emit received(msg.sender, msg.value);
99     }
100     function buyMonsterFossilByNagemon(uint256 _amount) public {
101         require(nagemonToken.transferFrom(msg.sender, ceoAddress, _amount));
102         tickets[msg.sender] = ticket(msg.sender, _amount);
103         emit receivedErc20(msg.sender, _amount);
104     }
105     function resetTiket(address _ticketOwner) public onlyTechnicalAddress returns (bool) {
106         tickets[_ticketOwner] = ticket(address(0), 0);
107         return true;
108     }
109     // @dev return the amount of token that msg.sender can receive based on the amount of ether that msg.sender sent
110     function getTokenAmount(uint256 _weiAmount) internal view returns (uint256) {
111         uint256 tokenDecimal = 18 - nagemonToken.decimals();
112         return _weiAmount * NagemonExchange / (10 ** tokenDecimal);
113     }
114     
115     function config(uint256 _NagemonExchange, address _technical) public onlyOwner returns (uint256, address){
116         NagemonExchange = _NagemonExchange;
117         technical = _technical;
118         return (NagemonExchange, technical);
119     }
120     function changeCeo(address payable _address) public onlyCeoAddress {
121         require(_address != address(0));
122         ceoAddress = _address;
123 
124     }
125 }