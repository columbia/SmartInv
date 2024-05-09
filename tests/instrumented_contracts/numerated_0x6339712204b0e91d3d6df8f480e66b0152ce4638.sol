1 pragma solidity ^0.4.11;
2 
3 interface token {
4   function transfer( address to, uint256 value) external returns (bool ok);
5   function balanceOf( address who ) external constant returns (uint256 value);
6 }
7 
8 contract EnvientaPreToken {
9 
10   string public constant symbol = "pENV";
11   string public constant name = "ENVIENTA pre-token";
12   uint8 public constant decimals = 18;
13   
14   event Transfer(address indexed from, address indexed to, uint256 value);
15 
16   mapping( address => uint256 ) _balances;
17   
18   uint256 public _supply = 30000000 * 10**uint256(decimals);
19   address _creator;
20   token public backingToken;
21   bool _buyBackMode = false;
22   
23   constructor() public {
24     _creator = msg.sender;
25     _balances[msg.sender] = _supply;
26   }
27   
28   function totalSupply() public constant returns (uint256 supply) {
29     return _supply;
30   }
31   
32   function balanceOf( address who ) public constant returns (uint256 value) {
33     return _balances[who];
34   }
35   
36   function enableBuyBackMode(address _backingToken) public {
37     require( msg.sender == _creator );
38     
39     backingToken = token(_backingToken);
40     _buyBackMode = true;
41   }
42   
43   function transfer( address to, uint256 value) public returns (bool ok) {
44     require( _balances[msg.sender] >= value );
45     require( _balances[to] + value >= _balances[to]);
46     
47     if( _buyBackMode ) {
48         require( msg.sender != _creator );
49         require( to == address(this) );
50         require( backingToken.balanceOf(address(this)) >= value );
51         
52         _balances[msg.sender] -= value;
53         _balances[to] += value;
54         emit Transfer( msg.sender, to, value );
55         
56         backingToken.transfer(msg.sender, value);
57         return true;
58     } else {
59         require( msg.sender == _creator );
60         
61         _balances[msg.sender] -= value;
62         _balances[to] += value;
63         emit Transfer( msg.sender, to, value );
64         return true;
65     }
66   }
67   
68 }