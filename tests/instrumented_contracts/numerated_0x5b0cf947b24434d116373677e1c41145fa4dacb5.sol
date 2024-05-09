1 pragma solidity ^0.4.8;
2 
3 // ERC20を元にしています。            url:https://github.com/ConsenSys/Tokens/blob/master/Token_Contracts/contracts/StandardToken.sol
4 contract SYLVIe {
5 
6   function () {
7       //if ether is sent to this address, send it back.
8       throw;
9   }
10 
11   string public name = "SYLVIe";                              // トークン名
12   uint8 public decimals = 0;                                  // 小数点以下何桁か
13   string public symbol = "SLV";                               // トークンの単位
14   uint256 public totalSupply = 100000000;                     // 総供給量
15   mapping (address => uint256) balances;                      // アドレスと所有トークン数のマッピング
16   mapping (address => mapping (address => uint256)) allowed;  // 第1引数のアドレスが第2引数のアドレスにいくらの送信を許可しているか
17 
18   event Transfer(address indexed from, address indexed to, uint value);
19   event Approval(address indexed owner, address indexed spender, uint value);
20 
21   function SYLVIe() {
22     balances[msg.sender] = totalSupply;
23   }
24 
25   function transfer(address _to, uint256 _value) returns (bool success) {
26       if (balances[msg.sender] >= _value && _value > 0) {
27           balances[msg.sender] -= _value;
28           balances[_to] += _value;
29           Transfer(msg.sender, _to, _value);
30           return true;
31       } else { return false; }
32   }
33 
34   function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
35       if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0) {
36           balances[_to] += _value;
37           balances[_from] -= _value;
38           allowed[_from][msg.sender] -= _value;
39           Transfer(_from, _to, _value);
40           return true;
41       } else { return false; }
42   }
43 
44   function balanceOf(address _owner) constant returns (uint256 balance) {
45     return balances[_owner];
46   }
47 
48   function approve(address _spender, uint256 _value) returns (bool success) {
49     allowed[msg.sender][_spender] = _value;
50     Approval(msg.sender, _spender, _value);
51     return true;
52   }
53 
54   function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
55     return allowed[_owner][_spender];
56   }
57 }