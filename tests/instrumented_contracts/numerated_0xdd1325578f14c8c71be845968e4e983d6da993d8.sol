1 /**
2  * @title ERC20Basic
3  * @dev Simpler version of ERC20 interface
4  * @dev see https://github.com/ethereum/EIPs/issues/179
5  */
6 contract ERC20Basic {
7   uint256 public totalSupply;
8   function balanceOf(address who) constant returns (uint256);
9   function transfer(address to, uint256 value) returns (bool);
10   event Transfer(address indexed from, address indexed to, uint256 value);
11 }
12 
13 /**
14  * This is the TokenTimelock contract from OpenZeppelin version 1.2.0
15  * The only changes are:
16  *   - all contract fields are declared as public
17  *   - removed deprecated claim() method
18  **/
19 
20 /**
21  * @title TokenTimelock
22  * @dev TokenTimelock is a token holder contract that will allow a
23  * beneficiary to extract the tokens after a given release time
24  */
25 contract TokenTimelock {
26 
27   // ERC20 basic token contract being held
28   ERC20Basic public token;
29 
30   // beneficiary of tokens after they are released
31   address public beneficiary;
32 
33   // timestamp when token release is enabled
34   uint public releaseTime;
35 
36   function TokenTimelock(ERC20Basic _token, address _beneficiary, uint _releaseTime) {
37     require(_releaseTime > now);
38     token = _token;
39     beneficiary = _beneficiary;
40     releaseTime = _releaseTime;
41   }
42 
43   /**
44    * @notice Transfers tokens held by timelock to beneficiary.
45    */
46   function release() {
47     require(now >= releaseTime);
48 
49     uint amount = token.balanceOf(this);
50     require(amount > 0);
51 
52     token.transfer(beneficiary, amount);
53   }
54 }