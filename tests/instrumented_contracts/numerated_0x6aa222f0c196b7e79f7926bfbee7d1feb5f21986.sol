1 // compiler: 0.4.19+commit.c4cbbb05.Emscripten.clang
2 pragma solidity ^0.4.19;
3 
4 contract owned {
5   address public owner;
6 
7   function owned() public {
8     owner = msg.sender;
9   }
10 
11   function changeOwner( address newowner ) public onlyOwner {
12     owner = newowner;
13   }
14 
15   function closedown() public onlyOwner { selfdestruct(owner); }
16 
17   modifier onlyOwner {
18     if (msg.sender != owner) { revert(); }
19     _;
20   }
21 }
22 
23 //
24 // mutable record of holdings
25 //
26 contract PREICO is owned {
27 
28   event Holder( address indexed holder, uint amount );
29 
30   uint public totalSupply_;
31 
32   address[] holders_;
33 
34   mapping( address => uint ) public balances_;
35 
36   function PREICO() public {}
37 
38   function count() public constant returns (uint) { return holders_.length; }
39 
40   function holderAt( uint ix ) public constant returns (address) {
41     return holders_[ix];
42   }
43 
44   function balanceOf( address hldr ) public constant returns (uint) {
45     return balances_[hldr];
46   }
47 
48   function add( address holder, uint amount ) onlyOwner public
49   {
50     require( holder != address(0) );
51     require( balances_[holder] + amount > balances_[holder] ); // overflow
52 
53     balances_[holder] += amount;
54     totalSupply_ += amount;
55 
56     if (!isHolder(holder))
57     {
58       holders_.push( holder );
59       Holder( holder, amount );
60     }
61   }
62 
63   function sub( address holder, uint amount ) onlyOwner public
64   {
65     require( holder != address(0) && balances_[holder] >= amount );
66 
67     balances_[holder] -= amount;
68     totalSupply_ -= amount;
69   }
70 
71   function isHolder( address who ) internal constant returns (bool)
72   {
73     for( uint ii = 0; ii < holders_.length; ii++ )
74       if (holders_[ii] == who) return true;
75 
76     return false;
77   }
78 
79 }