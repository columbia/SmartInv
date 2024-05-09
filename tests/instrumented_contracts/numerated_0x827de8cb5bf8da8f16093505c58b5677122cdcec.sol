1 /*
2 This file is part of the Cryptaur Contract.
3 
4 The CryptaurToken Contract is free software: you can redistribute it and/or
5 modify it under the terms of the GNU lesser General Public License as published
6 by the Free Software Foundation, either version 3 of the License, or
7 (at your option) any later version. See the GNU lesser General Public License
8 for more details.
9 
10 You should have received a copy of the GNU lesser General Public License
11 along with the CryptaurToken Contract. If not, see <http://www.gnu.org/licenses/>.
12 
13 @author Ilya Svirin <i.svirin@nordavind.ru>
14 Donation address 0x3Ad38D1060d1c350aF29685B2b8Ec3eDE527452B
15 */
16 
17 
18 pragma solidity ^0.4.11;
19 
20 contract owned {
21 
22     address public owner;
23     address public candidate;
24 
25     function owned() payable public {
26         owner = msg.sender;
27     }
28 
29     modifier onlyOwner {
30         require(owner == msg.sender);
31         _;
32     }
33 
34     function changeOwner(address _owner) onlyOwner public {
35         candidate = _owner;
36     }
37 
38     function confirmOwner() public {
39         require(candidate == msg.sender);
40         owner = candidate;
41         delete candidate;
42     }
43 }
44 
45 contract CryptaurToken is owned {
46 
47     address                      public cryptaurBackend;
48     bool                         public crowdsaleFinished;
49     uint                         public totalSupply;
50     mapping (address => uint256) public balanceOf;
51 
52     string  public standard    = 'Token 0.1';
53     string  public name        = 'Cryptaur';
54     string  public symbol      = "CPT";
55     uint8   public decimals    = 8;
56 
57     mapping (address => mapping (address => uint)) public allowed;
58     event Approval(address indexed owner, address indexed spender, uint value);
59     event Transfer(address indexed from, address indexed to, uint value);
60     event Mint(address indexed minter, uint tokens, uint8 originalCoinType, bytes32 originalTxHash);
61 
62     // Fix for the ERC20 short address attack
63     modifier onlyPayloadSize(uint size) {
64         require(msg.data.length >= size + 4);
65         _;
66     }
67 
68     function CryptaurToken(address _cryptaurBackend) public payable owned() {
69         cryptaurBackend = _cryptaurBackend;
70     }
71 
72     function changeBackend(address _cryptaurBackend) public onlyOwner {
73         cryptaurBackend = _cryptaurBackend;
74     }
75 
76     function mintTokens(address _minter, uint _tokens, uint8 _originalCoinType, bytes32 _originalTxHash) public {
77         require(msg.sender == cryptaurBackend);
78         require(!crowdsaleFinished);
79         balanceOf[_minter] += _tokens;
80         totalSupply += _tokens;
81         Transfer(this, _minter, _tokens);
82         Mint(_minter, _tokens, _originalCoinType, _originalTxHash);
83     }
84 
85     function finishCrowdsale() onlyOwner public {
86         crowdsaleFinished = true;
87     }
88 
89     function transfer(address _to, uint256 _value)
90         public onlyPayloadSize(2 * 32) {
91         require(balanceOf[msg.sender] >= _value);
92         require(balanceOf[_to] + _value >= balanceOf[_to]);
93         balanceOf[msg.sender] -= _value;
94         balanceOf[_to] += _value;
95         Transfer(msg.sender, _to, _value);
96     }
97 
98     function transferFrom(address _from, address _to, uint _value)
99         public onlyPayloadSize(3 * 32) {
100         require(balanceOf[_from] >= _value);
101         require(balanceOf[_to] + _value >= balanceOf[_to]); // overflow
102         require(allowed[_from][msg.sender] >= _value);
103         balanceOf[_from] -= _value;
104         balanceOf[_to] += _value;
105         allowed[_from][msg.sender] -= _value;
106         Transfer(_from, _to, _value);
107     }
108 
109     function approve(address _spender, uint _value) public {
110         allowed[msg.sender][_spender] = _value;
111         Approval(msg.sender, _spender, _value);
112     }
113 
114     function allowance(address _owner, address _spender) public constant
115         returns (uint remaining) {
116         return allowed[_owner][_spender];
117     }
118 }