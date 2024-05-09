1 pragma solidity ^0.4.2;
2 
3 contract RemiCoin {
4     //Common information about coin
5     string public name;
6     string public symbol;
7     uint8  public decimal;
8     uint256 public totalSupply;
9     
10     //Balance property which should be always associate with an address
11     mapping (address => uint256) public balanceOf;
12     
13     //These generates a public event on the blockchain that will notify clients
14     event Transfer(address indexed from, address indexed to, uint256 value);
15     
16     //Construtor for initial supply (The address who deployed the contract will get it) and important information
17     function RemiCoin(uint256 initial_supply, string _name, string _symbol, uint8 _decimal) {
18         balanceOf[msg.sender] = initial_supply;
19         name = _name;
20         symbol = _symbol;
21         decimal = _decimal;
22         totalSupply = initial_supply;
23     }
24     
25     //Function for transer the coin from one address to another
26     function transfer(address to, uint value) {
27         //checking the sender should have enough coins
28         if(balanceOf[msg.sender] < value) throw;
29         //checking for overflows
30         if(balanceOf[to] + value < balanceOf[to]) throw;
31         
32         //substracting the sender balance
33         balanceOf[msg.sender] -= value;
34         //adding the reciever balance
35         balanceOf[to] += value;
36         
37         // Notify anyone listening that this transfer took place
38         Transfer(msg.sender, to, value);
39     }
40 }