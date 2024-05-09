1 // https://github.com/ethereum/EIPs/issues/20
2 pragma solidity ^0.4.11;
3 
4 // Meetup 0: Genesis > 24th October 2017 > Madlab, Manchester, UK
5 contract BlockchainManchesterPioneer {
6     
7     uint256 public totalSupply = 60;
8     
9     event Transfer(address indexed _from, address indexed _to, uint256 _value);
10     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
11 
12     /*
13     NOTE:
14     The following variables are OPTIONAL vanities. One does not have to include them.
15     They allow one to customise the token contract & in no way influences the core functionality.
16     Some wallets/interfaces might not even bother to look at this information.
17     */
18     string public name  = "Blockchain Manchester Pioneer";
19     uint8 public decimals = 0;
20     string public symbol = "BMP";
21 
22     function BlockchainManchesterPioneer() {
23         // Give the creator all initial tokens
24         balances[msg.sender] = totalSupply;
25     }
26 
27     function transfer(address _to, uint256 _value) returns (bool success) {
28         require(balances[msg.sender] >= _value);
29         balances[msg.sender] -= _value;
30         balances[_to] += _value;
31         Transfer(msg.sender, _to, _value);
32         return true;
33     }
34 
35     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
36         uint256 allowance = allowed[_from][msg.sender];
37         require(balances[_from] >= _value && allowance >= _value);
38         balances[_to] += _value;
39         balances[_from] -= _value;
40         allowed[_from][msg.sender] -= _value;
41         Transfer(_from, _to, _value);
42         return true;
43     }
44 
45     function balanceOf(address _owner) constant returns (uint256 balance) {
46         return balances[_owner];
47     }
48 
49     function approve(address _spender, uint256 _value) returns (bool success) {
50         allowed[msg.sender][_spender] = _value;
51         Approval(msg.sender, _spender, _value);
52         return true;
53     }
54 
55     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
56         return allowed[_owner][_spender];
57     }
58 
59     mapping (address => uint256) balances;
60 
61     mapping (address => mapping (address => uint256)) allowed;
62 }