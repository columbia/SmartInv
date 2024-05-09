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
38 contract KeralaDonationContract is Ownable {
39     string public name;
40     string public symbol;
41     uint public decimals;
42     uint public totalSupply;
43     uint public amountRaised;
44     bool donationClosed = false;
45 
46     mapping (address => uint256) public balanceOf;
47     /* To track donated amount of a user */
48     mapping (address => uint256) public balance;
49     event FundTransfer(address backer, uint amount, bool isContribution);
50     event Transfer(address indexed from, address indexed to, uint256 value);
51 
52 
53     /**
54      * Constructor function
55      *
56      * Initializes contract with initial supply tokens to the creator of the contract
57      */
58     constructor() public {
59         name = 'Kerala Flood Donation Token';
60         symbol = 'KFDT';
61         decimals = 0;
62         totalSupply = 1000000;
63 
64         balanceOf[owner] = totalSupply;
65         amountRaised = 0;
66     }
67 
68     /**
69      * Internal transfer, only can be called by this contract
70      */
71     function _transfer(address _from, address _to, uint _value) internal {
72         require(_to != 0x0);
73         require(balanceOf[_from] >= _value);
74         require(balanceOf[_to] == 0);
75         require(_value == 1);
76 
77         balanceOf[_from] -= _value;
78         balanceOf[_to] += _value;
79         emit Transfer(_from, _to, _value);
80     }
81 
82     /**
83      * Transfer tokens
84      *
85      * Send `_value` tokens to `_to` from your account
86      *
87      * @param _to The address of the recipient
88      * @param _value the amount to send
89      */
90     function transfer(address _to, uint256 _value) public onlyOwner returns(bool success) {
91         _transfer(msg.sender, _to, _value);
92         return true;
93     }
94 
95     /* Stop taking donations */
96     function disableDonation() public onlyOwner returns(bool success) {
97       donationClosed = true;
98       return true;
99     }
100 
101 
102     /* Start taking donations */
103     function enableDonation() public onlyOwner returns(bool success) {
104       donationClosed = false;
105       return true;
106     }
107 
108     /* check user's donated amount */
109     function checkMyDonation() public view returns(uint) {
110       return balance[msg.sender];
111     }
112 
113     /* check if user is a backer */
114     function isBacker() public view returns(bool) {
115       if (balanceOf[msg.sender] > 0) {
116         return true;
117       }
118       return false;
119     }
120 
121     /**
122      * Fallback function
123      *
124      * The function without name is the default function that is called whenever anyone sends funds to a contract
125      */
126     function () payable public {
127         require(!donationClosed);
128         uint amount = msg.value;
129         amountRaised += amount;
130         balance[msg.sender] += amount;
131         transfer(msg.sender, 1);
132         owner.transfer(msg.value);
133     }
134 }