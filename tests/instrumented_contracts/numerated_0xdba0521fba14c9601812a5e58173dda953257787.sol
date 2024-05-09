1 pragma solidity ^0.4.19;
2 
3 contract SMINT {
4     struct Invoice {
5         address beneficiary;
6         uint amount;
7         address payer;
8     }
9     
10     address public owner;
11     string public name = 'SMINT';
12     string public symbol = 'SMINT';
13     uint8 public decimals = 18;
14     uint public totalSupply = 100000000000000000000000000000;
15     uint public currentInvoice = 0;
16     uint public lastEfficientBlockNumber;
17     
18     /* This creates an array with all balances */
19     mapping (address => uint) public balanceOf;
20     mapping (address => uint) public frozenBalanceOf;
21     mapping (address => uint) public successesOf;
22     mapping (address => uint) public failsOf;
23     mapping (address => mapping (address => uint)) public allowance;
24     mapping (uint => Invoice) public invoices;
25     
26     /* This generates a public event on the blockchain that will notify clients */
27     event Transfer(address indexed from, address indexed to, uint value);
28     
29     event Mine(address indexed miner, uint value, uint rewardAddition);
30     event Bill(uint invoiceId);
31     event Pay(uint indexed invoiceId);
32 
33     modifier onlyOwner {
34         if (msg.sender != owner) revert();
35         _;
36     }
37     
38     /* Initializes contract with initial supply tokens to the creator of the contract */
39     function SMINT() public {
40         owner = msg.sender;
41         balanceOf[msg.sender] = totalSupply;
42         lastEfficientBlockNumber = block.number;
43     }
44     
45     /* Internal transfer, only can be called by this contract */
46     function _transfer(address _from, address _to, uint _value) internal {
47         require(_to != 0x0);
48         require(balanceOf[_from] >= _value);
49         require(balanceOf[_to] + _value > balanceOf[_to]);
50         balanceOf[_from] -= _value;
51         balanceOf[_to] += _value;
52         Transfer(_from, _to, _value);
53     }
54     
55     /* Unfreeze not more than _value tokens */
56     function _unfreezeMaxTokens(uint _value) internal {
57         uint amount = frozenBalanceOf[msg.sender] > _value ? _value : frozenBalanceOf[msg.sender];
58         if (amount > 0) {
59             balanceOf[msg.sender] += amount;
60             frozenBalanceOf[msg.sender] -= amount;
61             Transfer(this, msg.sender, amount);
62         }
63     }
64     
65     function transferAndFreeze(address _to, uint _value) onlyOwner external {
66         require(_to != 0x0);
67         require(balanceOf[owner] >= _value);
68         require(frozenBalanceOf[_to] + _value > frozenBalanceOf[_to]);
69         balanceOf[owner] -= _value;
70         frozenBalanceOf[_to] += _value;
71         Transfer(owner, this, _value);
72     }
73     
74     /* Send coins */
75     function transfer(address _to, uint _value) public returns (bool success) {
76         _transfer(msg.sender, _to, _value);
77         return true;
78     }
79     
80     function bill(uint _amount) external {
81         require(_amount > 0);
82         invoices[currentInvoice] = Invoice({
83             beneficiary: msg.sender,
84             amount: _amount,
85             payer: 0x0
86         });
87         Bill(currentInvoice);
88         currentInvoice++;
89     }
90     
91     function pay(uint _invoiceId) external {
92         require(_invoiceId < currentInvoice);
93         require(invoices[_invoiceId].payer == 0x0);
94         _transfer(msg.sender, invoices[_invoiceId].beneficiary, invoices[_invoiceId].amount);
95         invoices[_invoiceId].payer = msg.sender;
96         Pay(_invoiceId);
97     }
98     
99     /* Transfer tokens from other address */
100     function transferFrom(address _from, address _to, uint _value) public returns (bool success) {
101         require(_value <= allowance[_from][msg.sender]);     // Check allowance
102         allowance[_from][msg.sender] -= _value;
103         _transfer(_from, _to, _value);
104         return true;
105     }
106     
107     /* Set allowance for other address */
108     function approve(address _spender, uint _value) public returns (bool success) {
109         allowance[msg.sender][_spender] = _value;
110         return true;
111     }
112     
113     function () external payable {
114         if (msg.value > 0) {
115             revert();
116         }
117         
118         uint minedAtBlock = uint(block.blockhash(block.number - 1));
119         uint minedHashRel = uint(sha256(minedAtBlock + uint(msg.sender) + block.timestamp)) % 1000000;
120         uint balanceRel = (balanceOf[msg.sender] + frozenBalanceOf[msg.sender]) * 1000000 / totalSupply;
121         if (balanceRel > 0) {
122             uint k = balanceRel;
123             if (k > 255) {
124                 k = 255;
125             }
126             k = 2 ** k;
127             balanceRel = 500000 / k;
128             balanceRel = 500000 - balanceRel;
129             if (minedHashRel < balanceRel) {
130                 uint reward = 100000000000000000 + minedHashRel * 1000000000000000;
131                 uint rewardAddition = reward * (block.number - lastEfficientBlockNumber) * 197 / 1000000;
132                 reward += rewardAddition;
133                 balanceOf[msg.sender] += reward;
134                 totalSupply += reward;
135                 _unfreezeMaxTokens(reward);
136                 Transfer(0, this, reward);
137                 Transfer(this, msg.sender, reward);
138                 Mine(msg.sender, reward, rewardAddition);
139                 successesOf[msg.sender]++;
140                 lastEfficientBlockNumber = block.number;
141             } else {
142                 Mine(msg.sender, 0, 0);
143                 failsOf[msg.sender]++;
144             }
145         } else {
146             revert();
147         }
148     }
149 }