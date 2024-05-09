1 pragma solidity ^0.4.4;
2 
3 contract Token {
4 
5     function totalSupply() constant returns (uint256 supply) {}
6 
7     function balanceOf(address _owner) constant returns (uint256 balance) {}
8 
9     function transfer(address _to, uint256 _value) returns (bool success) {}
10 
11     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {}
12 
13     function approve(address _spender, uint256 _value) returns (bool success) {}
14 
15 
16     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {}
17 
18     event Transfer(address indexed _from, address indexed _to, uint256 _value);
19     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
20     
21 }
22 
23 
24 
25 contract StandardToken is Token {
26 
27     function transfer(address _to, uint256 _value) returns (bool success) {
28         
29         if (balances[msg.sender] >= _value && _value > 0) {
30             balances[msg.sender] -= _value;
31             balances[_to] += _value;
32             Transfer(msg.sender, _to, _value);
33             return true;
34         } else { return false; }
35     }
36 
37     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
38       
39         if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0) {
40             balances[_to] += _value;
41             balances[_from] -= _value;
42             allowed[_from][msg.sender] -= _value;
43             Transfer(_from, _to, _value);
44             return true;
45         } else { return false; }
46     }
47 
48     function balanceOf(address _owner) constant returns (uint256 balance) {
49         return balances[_owner];
50     }
51 
52     function approve(address _spender, uint256 _value) returns (bool success) {
53         allowed[msg.sender][_spender] = _value;
54         Approval(msg.sender, _spender, _value);
55         return true;
56     }
57 
58     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
59       return allowed[_owner][_spender];
60     }
61 
62     mapping (address => uint256) balances;
63     mapping (address => mapping (address => uint256)) allowed;
64     uint256 public totalSupply;
65 }
66 
67 
68 
69 contract COMPANI is StandardToken {
70 
71     function () {
72        
73         throw;
74     }
75 
76     string public name;                   
77     uint8 public decimals;               
78     string public symbol;                 
79     string public version = 'H1.0';       
80  /* สมาร์ทคอนแทร็ก โดยบริษัท คัมปานี จำกัด, กรุงเทพฯ, ประเทศไทย เพื่อใช้ผลิตเหรียญสินค้าสกุลดิจิตอลชื่อ
81  ทีเอชบีซี โดยใช้เพื่อกิจการทางธุรกิจและเศรษฐสังคมทั่วไปทั้งในและต่างประเทศ อนึ่งไม่ใช่เพื่อการแลกเปลี่ยนเงิน
82  ตราหรือกิจกรรมอื่นใดที่อาจขัดแย้งกับพรบ.การเงิน และขอสงวนสิทธิ์ในการรับผิดจากการที่บุคคลนำไปใช้โดยผิดวัตถุประสงค์
83  ทุกกรณี */
84     function COMPANI(
85         ) {
86         balances[msg.sender] = 161803398875;               
87         totalSupply = 161803398875;                        
88         name = "Compani Ltd., (http://compani.org) - Common Token";                                   
89         decimals = 2;                            
90         symbol = "THBC";                               
91     }
92 
93     function approveAndCall(address _spender, uint256 _value, bytes _extraData) returns (bool success) {
94         allowed[msg.sender][_spender] = _value;
95         Approval(msg.sender, _spender, _value);
96 
97         if(!_spender.call(bytes4(bytes32(sha3("receiveApproval(address,uint256,address,bytes)"))), msg.sender, _value, this, _extraData)) { throw; }
98         return true;
99     }
100 }