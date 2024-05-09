1 pragma solidity ^0.4.18;
2 
3 interface Crowdsale {
4     function safeWithdrawal() public;
5     function shiftSalePurchase() payable public returns(bool success);
6 }
7 
8 interface Token {
9     function transfer(address _to, uint256 _value) public;
10 }
11 
12 contract ShiftSale {
13 
14     Crowdsale public crowdSale;
15     Token public token;
16 
17     address public crowdSaleAddress;
18     address[] public owners;
19     mapping(address => bool) public isOwner;
20     uint public fee;
21     /*
22      *  Constants
23      */
24     uint constant public MAX_OWNER_COUNT = 10;
25 
26     event FundTransfer(uint amount);
27     event OwnerAddition(address indexed owner);
28     event OwnerRemoval(address indexed owner);
29 
30     /// @dev Contract constructor sets initial Token, Crowdsale and the secret password to access the public methods.
31     /// @param _crowdSale Address of the Crowdsale contract.
32     /// @param _token Address of the Token contract.
33     /// @param _owners An array containing the owner addresses.
34     /// @param _fee The Shapeshift transaction fee to cover gas expenses.
35     function ShiftSale(
36         address _crowdSale,
37         address _token,
38         address[] _owners,
39         uint _fee
40     ) public {
41         crowdSaleAddress = _crowdSale;
42         crowdSale = Crowdsale(_crowdSale);
43         token = Token(_token);
44         for (uint i = 0; i < _owners.length; i++) {
45             require(!isOwner[_owners[i]] && _owners[i] != 0);
46             isOwner[_owners[i]] = true;
47         }
48         owners = _owners;
49         fee = _fee;
50     }
51 
52     modifier ownerDoesNotExist(address owner) {
53         require(!isOwner[owner]);
54         _;
55     }
56     modifier ownerExists(address owner) {
57         require(isOwner[owner]);
58         _;
59     }
60     modifier notNull(address _address) {
61         require(_address != 0);
62         _;
63     }
64     modifier validAmount() {
65         require((msg.value - fee) > 0);
66         _;
67     }
68 
69     /**
70      * Fallback function
71      *
72      * The function without name is the default function that is called whenever anyone sends funds to a contract
73      */
74     function()
75     payable
76     public
77     validAmount
78     {
79         if(crowdSale.shiftSalePurchase.value(msg.value - fee)()){
80             FundTransfer(msg.value - fee);
81         }
82     }
83 
84     /// @dev Returns list of owners.
85     /// @return List of owner addresses.
86     function getOwners()
87     public
88     constant
89     returns (address[])
90     {
91         return owners;
92     }
93     /// @dev Allows to transfer MTC tokens. Can only be executed by an owner.
94     /// @param _to Destination address.
95     /// @param _value quantity of MTC tokens to transfer.
96     function transfer(address _to, uint256 _value)
97     ownerExists(msg.sender)
98     public {
99         token.transfer(_to, _value);
100     }
101     /// @dev Allows to withdraw the ETH from the CrowdSale contract. Transaction has to be sent by an owner.
102     function withdrawal()
103     ownerExists(msg.sender)
104     public {
105         crowdSale.safeWithdrawal();
106     }
107     /// @dev Allows to refund the ETH to destination address. Transaction has to be sent by an owner.
108     /// @param _to Destination address.
109     /// @param _value Wei to transfer.
110     function refund(address _to, uint256 _value)
111     ownerExists(msg.sender)
112     public {
113         _to.transfer(_value);
114     }
115     /// @dev Allows to refund the ETH to destination addresses. Transaction has to be sent by an owner.
116     /// @param _to Array of destination addresses.
117     /// @param _value Array of Wei to transfer.
118     function refundMany(address[] _to, uint256[] _value)
119     ownerExists(msg.sender)
120     public {
121         require(_to.length == _value.length);
122         for (uint i = 0; i < _to.length; i++) {
123             _to[i].transfer(_value[i]);
124         }
125     }
126     /// @dev Allows to change the fee value. Transaction has to be sent by an owner.
127     /// @param _fee New value for the fee.
128     function setFee(uint _fee)
129     ownerExists(msg.sender)
130     public {
131         fee = _fee;
132     }
133 
134     /// @dev Withdraw all the eth on the contract. Transaction has to be sent by an owner.
135     function empty()
136     ownerExists(msg.sender)
137     public {
138         msg.sender.transfer(this.balance);
139     }
140 
141 }