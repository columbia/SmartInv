1 pragma solidity ^0.4.18;
2 
3 contract Token {
4   function transferFrom(address from, address to, uint256 value) public returns (bool success);
5   function transfer(address _to, uint256 _value) public returns (bool success);
6 }
7 
8 contract TokenPeg {
9   address public minimalToken;
10   address public signalToken;
11   bool public pegIsSetup;
12 
13   event Configured(address minToken, address sigToken);
14   event SignalingEnabled(address exchanger, uint tokenCount);
15   event SignalingDisabled(address exchanger, uint tokenCount);
16 
17   function TokenPeg() public {
18     pegIsSetup = false;
19   }
20 
21   function setupPeg(address _minimalToken, address _signalToken) public {
22     require(!pegIsSetup);
23     pegIsSetup = true;
24 
25     minimalToken = _minimalToken;
26     signalToken = _signalToken;
27 
28     Configured(_minimalToken, _signalToken);
29   }
30 
31   function tokenFallback(address _from, uint _value, bytes /*_data*/) public {
32     require(pegIsSetup);
33     require(msg.sender == signalToken);
34     giveMinimalTokens(_from, _value);
35   }
36 
37   function convertMinimalToSignal(uint amount) public {
38     require(Token(minimalToken).transferFrom(msg.sender, this, amount));
39     require(Token(signalToken).transfer(msg.sender, amount));
40 
41     SignalingEnabled(msg.sender, amount);
42   }
43 
44   function convertSignalToMinimal(uint amount) public {
45     require(Token(signalToken).transferFrom(msg.sender, this, amount));
46   }
47 
48   function giveMinimalTokens(address from, uint amount) private {
49     require(Token(minimalToken).transfer(from, amount));
50     
51     SignalingDisabled(from, amount);
52   }
53 
54 }