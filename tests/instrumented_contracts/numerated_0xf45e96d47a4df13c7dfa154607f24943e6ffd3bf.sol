1 pragma solidity ^0.4.24;
2 
3 contract ZTHInterface {
4     function buyAndSetDivPercentage(address _referredBy, uint8 _divChoice, string providedUnhashedPass) public payable returns (uint);
5     function balanceOf(address who) public view returns (uint);
6     function transfer(address _to, uint _value)     public returns (bool);
7     function transferFrom(address _from, address _toAddress, uint _amountOfTokens) public returns (bool);
8     function exit() public;
9     function sell(uint amountOfTokens) public;
10     function withdraw(address _recipient) public;
11 }
12 
13 // The Zethr Token Bankrolls aren't quite done being tested yet,
14 // so here is a bankroll shell that we are using in the meantime.
15 
16 // Will store tokens & divs @ the set div% until the token bankrolls are fully tested & battle ready
17 contract ZethrTokenBankrollShell {
18     // Setup Zethr
19     address ZethrAddress = address(0xD48B633045af65fF636F3c6edd744748351E020D);
20     ZTHInterface ZethrContract = ZTHInterface(ZethrAddress);
21     
22     address private owner;
23     
24     // Read-only after constructor
25     uint8 public divRate;
26     
27     modifier onlyOwner() {
28         require(msg.sender == owner);
29         _;
30     }
31     
32     constructor (uint8 thisDivRate) public {
33         owner = msg.sender;
34         divRate = thisDivRate;
35     }
36     
37     // Accept ETH
38     function () public payable {}
39     
40     // Buy tokens at this contract's divRate
41     function buyTokens() public payable onlyOwner {
42         ZethrContract.buyAndSetDivPercentage.value(address(this).balance)(address(0x0), divRate, "0x0");
43     }
44     
45     // Transfer tokens to newTokenBankroll
46     // Transfer dividends to master bankroll
47     function transferTokensAndDividends(address newTokenBankroll, address masterBankroll) public onlyOwner {
48         // Withdraw divs to new masterBankroll
49         ZethrContract.withdraw(masterBankroll);
50         
51         // Transfer tokens to newTokenBankroll
52         ZethrContract.transfer(newTokenBankroll, ZethrContract.balanceOf(address(this)));
53     }
54 }