1 /**
2  * @title ERC20Basic
3  * @dev Simpler version of ERC20 interface
4  * @dev see https://github.com/ethereum/EIPs/issues/20
5  */
6 contract ERC20Basic {
7   uint public totalSupply;
8   function balanceOf(address who) constant returns (uint);
9   function transfer(address to, uint value);
10   event Transfer(address indexed from, address indexed to, uint value);
11 }
12 
13 /**
14  * @title TokenTimelock
15  * @dev TokenTimelock is a token holder contract that will allow a
16  * beneficiary to extract the tokens after a time has passed
17  */
18 contract TokenTimelock {
19 
20   // ERC20 basic token contract being held
21   ERC20Basic token;
22 
23   // beneficiary of tokens after they are released
24   address beneficiary;
25 
26   // timestamp where token release is enabled
27   uint releaseTime;
28 
29   function TokenTimelock(ERC20Basic _token, address _beneficiary, uint _releaseTime) {
30     require(_releaseTime > now);
31     token = _token;
32     beneficiary = _beneficiary;
33     releaseTime = _releaseTime;
34   }
35 
36   /**
37    * @dev beneficiary claims tokens held by time lock
38    */
39   function claim() {
40     require(msg.sender == beneficiary);
41     require(now >= releaseTime);
42 
43     uint amount = token.balanceOf(this);
44     require(amount > 0);
45 
46     token.transfer(beneficiary, amount);
47   }
48 }