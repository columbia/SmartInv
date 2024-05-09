1 pragma solidity ^0.4.24;
2 contract Ownable {
3   address public owner;
4   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
5   function Ownable() public {
6     owner = msg.sender;
7   }
8 
9   modifier onlyOwner() {
10     require(msg.sender == owner);
11     _;
12   }
13 
14   function transferOwnership(address newOwner) public onlyOwner {
15     require(newOwner != address(0));
16     OwnershipTransferred(owner, newOwner);
17     owner = newOwner;
18   }
19 }
20 
21 contract LoveToken is Ownable{
22     uint256 public totalSupply;
23     function balanceOf(address _owner) constant returns (uint256 balance);
24     function transfer(address _to, uint256 _value) returns (bool success);
25     event Transfer(address indexed _from, address indexed _to, uint256 _value);
26 }
27 
28 contract PiaoPiaoToken is LoveToken {
29     mapping (address => uint256) balances;
30     string public name;                   
31     uint8 public decimals;               
32     string public symbol;
33     string public loveUrl;
34     
35     function PiaoPiaoToken() {
36         balances[msg.sender] = 5201314; 
37         totalSupply = 5201314;         
38         name = "PiaoPiao Token";                   
39         decimals = 0;          
40         symbol = "PPT";  
41     }
42     
43     function setLoveUrl(string _loveUrl) onlyOwner public returns (bool success) {
44         loveUrl = _loveUrl;
45         return true;
46     }
47     
48     function transfer(address _to, uint256 _value) returns (bool success) {
49         require(balances[msg.sender] >= _value);
50         balances[msg.sender] -= _value;
51         balances[_to] += _value;
52         Transfer(msg.sender, _to, _value);
53         return true;
54     }
55 
56     function balanceOf(address _owner) constant returns (uint256 balance) {
57         return balances[_owner];
58     }
59 }