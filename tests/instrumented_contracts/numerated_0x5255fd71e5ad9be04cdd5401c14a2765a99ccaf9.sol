1 pragma solidity ^0.4.24;
2 
3 
4 contract Ownable {
5   address public owner;
6 
7   /**
8    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
9    * account.
10    */
11   constructor() public {
12     owner = msg.sender;
13   }
14 
15 
16   /**
17    * @dev Throws if called by any account other than the owner.
18    */
19   modifier onlyOwner() {
20     require(msg.sender == owner);
21     _;
22   }
23 
24 
25   /**
26    * @dev Allows the current owner to transfer control of the contract to a newOwner.
27    * @param newOwner The address to transfer ownership to.
28    */
29   function transferOwnership(address newOwner) public onlyOwner {
30     if (newOwner != address(0)) {
31       owner = newOwner;
32     }
33   }
34 
35 }
36 
37 
38 contract HelpingBlocksContract is Ownable {
39     string public name;
40     string public symbol;
41     uint public decimals;
42     uint public totalSupply;
43     string public description;
44     bool public donationClosed = false;
45 
46     mapping (address => uint256) public balanceOf;
47     /* To track donated amount of a user */
48     mapping (address => uint256) public myDonation;
49     event Transfer(address indexed from, address indexed to, uint256 value);
50 
51 
52     /**
53      * Constructor function
54      *
55      * Initializes contract with initial supply tokens to the creator of the contract
56      */
57     constructor() public {
58         name = 'Helping Blocks Token';
59         symbol = 'HBT';
60         decimals = 0;
61         totalSupply = 10000000;
62         description = "Kerala Flood Relief Fund";
63         balanceOf[owner] = totalSupply;
64     }
65 
66     /**
67      * Internal transfer, only can be called by this contract
68      */
69     function _transfer(address _from, address _to, uint _value) internal {
70         balanceOf[_from] -= _value;
71         balanceOf[_to] += _value;
72         emit Transfer(_from, _to, _value);
73     }
74 
75     /**
76      * Transfer tokens
77      *
78      * Send `_value` tokens to `_to` from your account
79      *
80      * @param _to The address of the recipient
81      * @param _value the amount to send
82      */
83     function transfer(address _to, uint256 _value) public onlyOwner returns(bool success) {
84         _transfer(owner, _to, _value);
85         return true;
86     }
87 
88     /* Stop taking donations */
89     function disableDonation() public onlyOwner returns(bool success) {
90       donationClosed = true;
91       return true;
92     }
93 
94 
95     /* Start taking donations */
96     function enableDonation() public onlyOwner returns(bool success) {
97       donationClosed = false;
98       return true;
99     }
100 
101     function setDescription(string str) public onlyOwner returns(bool success) {
102       description = str;
103       return true;
104     }
105 
106 
107     /**
108      * Fallback function
109      *
110      * The function without name is the default function that is called whenever anyone sends funds to a contract
111      */
112     function () payable public {
113       require(!donationClosed);
114       myDonation[msg.sender] += msg.value;
115       if (balanceOf[msg.sender] < 1) {
116         _transfer(owner, msg.sender, 1);
117       }
118     }
119 
120     function safeWithdrawal(uint256 _value) payable public onlyOwner {
121       owner.transfer(_value);
122     }
123 }