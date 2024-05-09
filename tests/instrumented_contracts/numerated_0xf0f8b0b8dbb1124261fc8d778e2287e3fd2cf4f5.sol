1 pragma solidity ^0.4.8;
2 
3 
4 contract owned 
5    {
6    address public owner;
7 
8    function owned() 
9       {
10       owner = msg.sender;
11       }
12 
13    modifier onlyOwner 
14       {
15       if (msg.sender != owner) throw;
16       _;
17       }
18    }
19 
20 
21 contract bitqyRecipient 
22    { 
23    function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData); 
24    }
25 
26 
27 contract bitqy is owned {
28    /*   Public variables of the coin   */
29    uint256 public totalSupply;
30    string public name;
31    string public symbol;
32    uint8 public decimals;
33 
34 
35    mapping (address => uint256) public balanceOf;   //   Array of balances
36    mapping (address => bool) public frozenAccount;   //   Array of frozen accounts
37    mapping (address => mapping (address => uint256)) public allowance;   //   Array of allowances
38 
39 
40    event Transfer(address indexed from, address indexed to, uint256 value);
41    event FrozenFunds(address target, bool frozen);
42 
43 
44    /*   Initializes contract with the initial supply of coins to the creator of the contract   */
45    function bitqy(
46          uint256 initialSupply,
47          string tokenName,
48          uint8 decimalUnits,
49          string tokenSymbol
50          ) 
51       {
52       balanceOf[msg.sender] = initialSupply;
53       totalSupply = initialSupply;
54       name = tokenName;
55       symbol = tokenSymbol;
56       decimals = decimalUnits;
57       }
58 
59 
60    /*   Send coins   */
61    function transfer(address _to, uint256 _value) returns (bool success) 
62       {
63       /*   Checks if sender has enough balance, checks for overflows and checks if the account is frozen   */
64       if ((balanceOf[msg.sender] < _value) || (balanceOf[_to] + _value < balanceOf[_to]) || (frozenAccount[msg.sender]) || (frozenAccount[_to]))
65          {
66          return false;
67          }
68 
69       else
70          {
71          /*   Add and subtract new balances   */
72          balanceOf[msg.sender] -= _value;
73          balanceOf[_to] += _value;
74 
75          /*   Notify anyone listening that this transfer took place   */
76          Transfer(msg.sender, _to, _value);
77          return true;
78          }
79       }
80 
81 
82     /*   Allow another contract to spend some coins on your behalf   */
83     function approve(address _spender, uint256 _value) returns (bool success) 
84       {
85       if ((frozenAccount[msg.sender]) || (frozenAccount[_spender]))
86          {
87          return false;
88          }
89 
90       else
91          {
92          allowance[msg.sender][_spender] = _value;
93          bitqyRecipient spender = bitqyRecipient(_spender);
94          return true;
95          }
96       }
97 
98 
99 
100    /*   A contract attempts to get the coins   */
101    function transferFrom(address _from, address _to, uint256 _value) returns (bool success) 
102       {
103       if ((balanceOf[_from] < _value) || (balanceOf[_to] + _value < balanceOf[_to]) || (_value > allowance[_from][msg.sender]) || (frozenAccount[msg.sender]) || (frozenAccount[_from]) || (frozenAccount[_to]))
104          {
105          return false;
106          }
107 
108       else
109          {
110          balanceOf[_from] -= _value;
111          allowance[_from][msg.sender] -= _value;
112          balanceOf[_to] += _value;
113          Transfer(_from, _to, _value);
114          return true;
115          }
116       }
117 
118 
119    function freezeAccount(address target, bool freeze) onlyOwner 
120       {
121       frozenAccount[target] = freeze;
122       FrozenFunds(target, freeze);
123       }
124 
125 
126    function legal() constant returns (string content) 
127       {
128       content = "bitqy, the in-app token for bitqyck\n\nbitqy is a cryptocurrency token for the marketplace platform bitqyck and the general market as it is accepted by businesses and consumers globally. bitqy will be allocated by the directors of bitqyck, Inc. Once allocated, bitqyck relinquishes control of the allocated bitqy\n\nThe latest and most up to date legal disclosures can always be found on bitqy.org.\n\nAdditionally, bitqyck, Inc., a Texas corporation, certifies:\n   * that it has authorized the minting of ten billion digital tokens known as \"bitqy tokens\" or \"bitqy coins,\" created on the Ethereum Blockchain App Platform and, further certifies,\n   * that through its directors and founders, has duly authorized one billion shares of common stock as the only class of ownership shares in the Corporation, and further certifies,\n   * that the bitqy tokens are only created by the smart contract that these certifications are enumerated within and, further certifies,\n   * that the holder of a bitqy token, is also the holder of one-tenth of a share of bitqyck, Inc. common stock, and further certifies,\n   * that the holder of this coin shall enjoy the rights and benefits as a shareholder of bitqyck, Inc. pursuant to the shareholder rules as determined from time to time by the directors or majority shareholders of bitqyck, Inc. and ONLY IF the bitqy holder has his/her bitqy tokens in the official bitqy wallet operated and maintained by bitqyck, Inc., and further certifies,\n   * pursuant to the terms and conditions that the directors and founders attach to the bitqy token, and further certifies\n   * that this bitqy token is freely transferable by the holder hereof in any manner, which said holder deems appropriate and reasonable.\nThe holder of this bitqy token certifies that he or she has ownership and possession pursuant to a legal transaction or transfer from the prior holder.\n\n";
129       return content;
130       }
131 
132 
133 
134    /*   If no other functions are matched   */
135    function () 
136       {
137       throw;   //   Prevents accidental sending of ether and other potential problems
138       }
139 
140 
141    }