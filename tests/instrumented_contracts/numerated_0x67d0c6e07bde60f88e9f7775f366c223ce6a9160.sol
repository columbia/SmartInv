1 pragma solidity 0.4.10;
2 
3 contract BAT_ATM{
4     Token public bat = Token(0x0D8775F648430679A709E98d2b0Cb6250d2887EF);
5     address owner = msg.sender;
6 
7     uint    public pausedUntil;
8     uint    public BATsPerEth;// BAT/ETH
9 
10     modifier onlyActive(){ if(pausedUntil < now){ _; }else{ throw; } }
11     
12     function () payable onlyActive{//buy some BAT. Use gasLimit:100000
13         if(!bat.transfer(msg.sender, (msg.value * BATsPerEth))){ throw; }
14     }
15 //only owner
16     modifier onlyOwner(){ if(msg.sender == owner) _; }
17 
18     function changeRate(uint _BATsPerEth) onlyOwner{
19         pausedUntil = now + 300; //no new bids for 5 minutes (protects taker)
20         BATsPerEth = _BATsPerEth;
21     }
22 
23     function withdrawETH() onlyOwner{
24         if(!msg.sender.send(this.balance)){ throw; }
25     }
26     function withdrawBAT() onlyOwner{
27         if(!bat.transfer(msg.sender, bat.balanceOf(this))){ throw; }
28     }
29 }
30 
31 // BAToken contract found at:
32 // https://etherscan.io/address/0x0D8775F648430679A709E98d2b0Cb6250d2887EF#code
33 contract Token {
34     function balanceOf(address _owner) constant returns (uint256 balance);
35     function transfer(address _to, uint256 _value) returns (bool success);
36 }