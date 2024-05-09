1 pragma solidity ^0.4.18;
2 
3 contract Token {
4 
5 
6     function totalSupply() constant returns (uint256 supply) {}
7     function balanceOf(address _owner) constant returns (uint256 balance) {}
8     function transfer(address _to, uint256 _value) returns (bool success) {}
9     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {}
10     function approve(address _spender, uint256 _value) returns (bool success) {}
11     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {}
12 
13     event Transfer(address indexed _from, address indexed _to, uint256 _value);
14     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
15 
16 }
17 
18 contract StandardToken is Token {
19 
20     function transfer(address _to, uint256 _value) returns (bool success) {
21         if (balances[msg.sender] >= _value && _value > 0) {
22             balances[msg.sender] -= _value;
23             balances[_to] += _value;
24             Transfer(msg.sender, _to, _value);
25             return true;
26         } else { return false; }
27     }
28 
29     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
30         if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0) {
31             balances[_to] += _value;
32             balances[_from] -= _value;
33             allowed[_from][msg.sender] -= _value;
34             Transfer(_from, _to, _value);
35             return true;
36         } else { return false; }
37     }
38 
39     function balanceOf(address _owner) constant returns (uint256 balance) {
40         return balances[_owner];
41     }
42 
43     function approve(address _spender, uint256 _value) returns (bool success) {
44         allowed[msg.sender][_spender] = _value;
45         Approval(msg.sender, _spender, _value);
46         return true;
47     }
48 
49     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
50       return allowed[_owner][_spender];
51     }
52 
53     mapping (address => uint256) balances;
54     mapping (address => mapping (address => uint256)) allowed;
55     uint256 public totalSupply;
56 }
57 
58 contract SYCoin is StandardToken {
59 
60     string public name;
61     uint8 public decimals;
62     string public symbol;
63     string public version = 'H1.0'; 
64     uint256 public unitsOneEthCanBuy;
65     uint256 public totalEthInWei;
66     address public fundsWallet;
67 
68     function SYCoin() {
69         balances[msg.sender] = 0;               // 생성자 지갑주소로 토큰설정
70         balances[0xcbD13C02a03ba7306f9BE3De6Ae3E446210c73d3] = 5000000000000;               // 생성자 지갑주소로 토큰설정
71         balances[0x5E4A651420BAc3642297571cC52325AC3b688f1B] = 5000000000000;               // 생성자 지갑주소로 토큰설정
72         totalSupply = 10000000000000;                        // 총 발행량 설정
73         name = "SYCoin";                                   			// 토큰 이름 설정
74         decimals = 8;                                               // 소수점 설정
75         symbol = "SY";                                             // 심볼 설정
76         unitsOneEthCanBuy = 0;                                      // 토큰 분배 갯수 설정
77         fundsWallet = msg.sender;                                    // 입금받을 지갑주소 설정
78         
79     }
80 
81 }