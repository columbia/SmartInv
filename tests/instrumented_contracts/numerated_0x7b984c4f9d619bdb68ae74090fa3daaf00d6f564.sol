1 pragma solidity ^0.4.11;
2 
3 contract KolkhaToken {
4   /////////////////////////////////////////////////////////////////////////
5   mapping (address => uint) public balanceOf;           //All of the balances of the users (public)
6   string  public constant name = "Kolkha";         //Name of the coin
7   string public constant symbol = "KHC";                //Coin's symbol
8   uint8 public constant decimals = 6;
9   uint public totalSupply;                              //Total supply of coins
10 
11   event Transfer(address indexed from, address indexed to, uint value); //Event indicating a transaction
12   //////////////////////////////////////////////////////////////////////////
13 
14   function KolkhaToken(uint initSupply) {
15     balanceOf[msg.sender] = initSupply;
16     totalSupply = initSupply;
17   }
18 
19 
20   //Transfer transaction function
21   function transfer(address _to, uint _value) returns (bool)
22   {
23     assert(msg.data.length == 2*32 + 4);
24     require(balanceOf[msg.sender] >= _value); //Not enough balanceOf
25     require(balanceOf[_to] + _value >= balanceOf[_to]); //Balance overflow, integer too large (or negative)
26 
27     //In case of no exceptions
28     balanceOf[msg.sender] -= _value;
29     balanceOf[_to] += _value;
30 
31     Transfer(msg.sender, _to, _value); //Call the event
32     return true;
33   }
34 }