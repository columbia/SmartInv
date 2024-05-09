1 pragma solidity ^0.4.18;
2  
3 /*
4  Ⓒ  DixiEnergy.com
5  
6  Investing in electricity DXE you multiply your capital.
7   Money mining money.
8 
9  Ⓒ2017   DXE tokens
10  
11 */
12 
13 
14 contract miningrealmoney {
15     address public owner;
16     address public newowner;
17 function miningrealmoney() payable {
18     owner = msg.sender;
19 }
20 modifier onlyOwner {
21     require(owner == msg.sender);
22     _;
23 }
24 function changeOwner(address _owner) onlyOwner public {
25 newowner = _owner;
26 
27 }
28 function confirmOwner() public {
29     require(newowner == msg.sender);
30     owner = newowner;
31 }
32 }
33 contract Limitedsale is miningrealmoney{
34 
35     uint256 public totalSupply;
36     mapping (address => uint256) public balanceOf;
37     
38     
39     event Transfer(address indexed from, address indexed to, uint256 value);
40 function Limitedsale() payable miningrealmoney() {
41     totalSupply = 10000000000;
42 balanceOf[this] = 2500000000;
43 balanceOf[owner] = totalSupply - balanceOf[this];
44 Transfer(this, owner, balanceOf[owner]);
45 }
46     
47     function () payable {
48         require(balanceOf[this] > 0);
49         uint256 tokens = 300 * msg.value/10000000000000000;
50         if (tokens > balanceOf[this]) {
51             tokens = balanceOf[this];
52             uint valueWei = tokens * 10000000000000000 / 300;
53             msg.sender.transfer(msg.value - valueWei);
54         }
55     require(tokens > 0);
56     balanceOf[msg.sender] += tokens;
57     balanceOf[this] -= tokens;
58     Transfer(this, msg.sender, tokens);
59     }
60 }
61 
62 contract DiXiEnergy is Limitedsale {
63     string public standart = 'Token 0.1';
64     string public name = 'DiXiEnergy';
65     string public symbol = "DXE";
66     uint8 public decimals = 2;
67 
68     
69      modifier onlyPayloadSize(uint size) {
70      if(msg.data.length < size + 4) {
71        throw;
72      }
73      _;
74   }
75   function transfer(address _to, uint _value) onlyPayloadSize(2 * 32) {
76     require(balanceOf[msg.sender] >= _value);
77      balanceOf[msg.sender] -= _value;
78 balanceOf[_to] += _value;  
79     Transfer(msg.sender, _to, _value);
80   }
81 }
82 
83 contract SmartContract is DiXiEnergy {
84     function SmartContract() payable DiXiEnergy() {}
85     function withdraw() public onlyOwner {
86         owner.transfer(this.balance);
87     }
88 
89 }
90 
91 /*
92   Ⓒ2017  DixiEnergy.com
93   
94   Investing in electricity DXE you multiply your capital.
95   Money mining money.
96   Ⓒ2017   DXE tokens
97 */