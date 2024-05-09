1 pragma solidity ^0.4.23;
2 
3 contract guess_coin{
4     super_rand public rand_addr;
5     uint256 win;
6     address public owner;
7     
8     constructor(address _addr) public {
9         rand_addr = super_rand(_addr);
10         win = 200;
11         owner = msg.sender;
12     }
13     
14     //if rand%2 == true pay 2*value
15     function() public payable {
16         if( rand_addr.s_rand( msg.sender, msg.value) ){
17             msg.sender.transfer(msg.value * win/100);
18         }
19     }
20     function set_rand_addr(address _addr, uint256 _win) public {
21         require( msg.sender == owner);
22         rand_addr = super_rand(_addr);
23         win = _win;
24     }
25     function get_eth() public {
26         require( msg.sender == owner);
27         owner.transfer(address(this).balance);
28     }
29 }
30 
31 contract super_rand{
32     function s_rand( address p_addr, uint256 _thisbalance) public returns( bool);
33 }