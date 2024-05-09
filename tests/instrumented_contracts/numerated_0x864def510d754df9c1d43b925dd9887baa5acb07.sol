1 pragma solidity ^0.4.11;
2 contract owned {
3     address public owner;
4     address public authorisedContract;
5     function owned() {
6         owner = msg.sender;
7     }
8 
9     modifier onlyOwner {
10         require(msg.sender == owner);
11         _;
12     }
13     modifier onlyAuthorisedAddress{
14         require(msg.sender == authorisedContract);
15         _;
16     }
17 
18     function transferOwnership(address newOwner) onlyOwner {
19         owner = newOwner;
20     }
21     modifier onlyPayloadSize(uint size) {
22      assert(msg.data.length == size + 4);
23      _;
24     }
25 }
26 
27 contract tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData); }
28 
29 contract MyToken is owned {
30     /* Public variables of the token */
31     string public name = "DankToken";
32     string public symbol = "DANK";
33     uint8 public decimals = 18;
34     uint256 _totalSupply;
35     uint256 public amountRaised = 0;
36     uint256 public amountOfTokensPerEther = 500;
37         /* this makes an array with all frozen accounts. This is needed so voters can not send their funds while the vote is going on and they have already voted      */
38     mapping (address => bool) public frozenAccounts;
39         /* This creates an array with all balances */ 
40     mapping (address => uint256) _balanceOf;
41     mapping (address => mapping (address => uint256)) _allowance;
42     bool public crowdsaleClosed = false;
43     /* This generates a public event on the blockchain that will notify clients */
44     event Transfer(address indexed _from, address indexed _to, uint256 _value);
45     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
46     event FrozenFunds(address target, bool frozen);
47     /* Initializes contract with initial supply tokens to the creator of the contract */
48     function MyToken() {
49         _balanceOf[msg.sender] = 4000000000000000000000;              
50         _totalSupply = 4000000000000000000000;                 
51         Transfer(this, msg.sender,4000000000000000000000);
52     }
53     function changeAuthorisedContract(address target) onlyOwner
54     {
55         authorisedContract = target;
56     }
57     function() payable{
58         require(!crowdsaleClosed);
59         uint amount = msg.value;
60         amountRaised += amount;
61         uint256 totalTokens = amount * amountOfTokensPerEther;
62         _balanceOf[msg.sender] += totalTokens;
63         _totalSupply += totalTokens;
64         Transfer(this,msg.sender, totalTokens);
65     }
66      function totalSupply() constant returns (uint TotalSupply){
67         TotalSupply = _totalSupply;
68      }
69       function balanceOf(address _owner) constant returns (uint balance) {
70         return _balanceOf[_owner];
71      }
72      function closeCrowdsale() onlyOwner{
73          crowdsaleClosed = true;
74      }
75      function openCrowdsale() onlyOwner{
76          crowdsaleClosed = false;
77      }
78      function changePrice(uint newAmountOfTokensPerEther) onlyOwner{
79          require(newAmountOfTokensPerEther <= 500);
80          amountOfTokensPerEther = newAmountOfTokensPerEther;
81      }
82      function withdrawal(uint256 amountOfWei) onlyOwner{
83          if(owner.send(amountOfWei)){}
84      }
85      function freezeAccount(address target, bool freeze) onlyAuthorisedAddress
86      {
87          frozenAccounts[target] = freeze;
88          FrozenFunds(target, freeze);
89      } 
90      
91     /* Send coins */
92     function transfer(address _to, uint256 _value) onlyPayloadSize(2*32) {
93         require(!frozenAccounts[msg.sender]);
94         require(_balanceOf[msg.sender] > _value);          // Check if the sender has enough
95         require(_balanceOf[_to] + _value > _balanceOf[_to]); // Check for overflows
96         _balanceOf[msg.sender] -= _value;                     // Subtract from the sender
97         _balanceOf[_to] += _value;                            // Add the same to the recipient
98         Transfer(msg.sender, _to, _value);                   // Notify anyone listening that this transfer took place
99     }
100     /* Allow another contract to spend some tokens in your behalf */
101     function approve(address _spender, uint256 _value)onlyPayloadSize(2*32)
102         returns (bool success)  {
103         _allowance[msg.sender][_spender] = _value;
104         Approval(msg.sender, _spender, _value);
105         return true;
106     } 
107 
108     /* A contract attempts to get the coins */
109     function transferFrom(address _from, address _to, uint256 _value) returns (bool success)  {
110         require(!frozenAccounts[_from]);
111         require(_balanceOf[_from] > _value);                 // Check if the sender has enough
112         require(_balanceOf[_to] + _value > _balanceOf[_to]);  // Check for overflows
113         require(_allowance[_from][msg.sender] >= _value);     // Check allowance
114         _balanceOf[_from] -= _value;                           // Subtract from the sender
115         _balanceOf[_to] += _value;                             // Add the same to the recipient
116         _allowance[_from][msg.sender] -= _value;
117         Transfer(_from, _to, _value);
118         return true;
119     }
120     function allowance(address _owner, address _spender) constant returns (uint remaining) {
121         return _allowance[_owner][_spender];
122     }
123 }