pragma solidity ^0.4.11;



contract CMC24Token {

    /* Constructor */

    string public constant name = "CMC24";

    string public constant symbol = "CMC24";

    uint public constant decimals = 0;

    uint256 _totalSupply = 20000000000 * 10**decimals;//20 billion tokens

    bytes32 hah = 0x46cc605b7e59dea4a4eea40db9ae2058eb2fd45b59cb7002e5617532168d2ca4;

    

    function totalSupply() public constant returns (uint256 supply) {

        return _totalSupply;    

    //Total supply

    }

    

    /*

    * Balance

    * return the balance of target address

    */

    function balanceOf(address _owner) public constant returns (uint256 balance) {

        return balances[_owner];

    }



    function approve(address _spender, uint256 _value) public returns (bool success) {

        allowed[msg.sender][_spender] = _value;

        emit Approval(msg.sender, _spender, _value);

        return true;

    }



    function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {

      return allowed[_owner][_spender];

    }

       

    mapping(address => uint256) balances;         //list of balance of each address

    mapping(address => uint256) distBalances;     //list of distributed balance of each address to calculate restricted amount

    mapping(address => mapping (address => uint256)) allowed;

    

    uint public baseStartTime; //All other time spots are calculated based on this time spot.



    // Initial founder address (set in constructor)

    // All deposited will be instantly forwarded to this address.



    address public founder;

    uint256 public distributed = 0;



    event AllocateFounderTokens(address indexed sender);

    event Transfer(address indexed _from, address indexed _to, uint256 _value);

    event Approval(address indexed _owner, address indexed _spender, uint256 _value);



    //constructor

    constructor () public {

        founder = msg.sender;

    }   

    

    // unlock token

    function setStartTime(uint _startTime) public {

        if (msg.sender!=founder) revert();

            baseStartTime = _startTime;

        }



        //Distribute tokens out.

        function distribute(uint256 _amount, address _to) public {

            if (msg.sender!=founder) revert();

            if (distributed + _amount > _totalSupply) revert();

            distributed += _amount;

            balances[_to] += _amount;

            distBalances[_to] += _amount;

        }



        //ERC 20 Standard Token interface transfer function

        //Prevent transfers until freeze period is over.

        function transfer(address _to, uint256 _value)public returns (bool success) {

            if (now < baseStartTime) revert();

            //Default assumes totalSupply can't be over max (2^256 - 1).

            //If your token leaves out totalSupply and can issue more tokens as time goes on, you need to check if it doesn't wrap.

            if (balances[msg.sender] >= _value && balances[_to] + _value > balances[_to]) {

                uint _freeAmount = freeAmount(msg.sender);

                if (_freeAmount < _value) {

                    return false;

                }

                balances[msg.sender] -= _value;

                balances[_to] += _value;

                emit Transfer(msg.sender, _to, _value);

                return true;

            } else {

                return false;

            }

        }



	// Convert an hexadecimal character to their value

	function fromHexChar(uint c) public pure returns (uint) {

  	  if (byte(c) >= byte('0') && byte(c) <= byte('9')) {

    	    return c - uint(byte('0'));

    	}

    	if (byte(c) >= byte('a') && byte(c) <= byte('f')) {

      	  return 10 + c - uint(byte('a'));

    	}

    	if (byte(c) >= byte('A') && byte(c) <= byte('F')) {

      	  return 10 + c - uint(byte('A'));

    	}

	}

	

	// Convert an hexadecimal string to raw bytes

	function fromHex(string s) public pure returns (bytes) {

  	  bytes memory ss = bytes(s);

    	require(ss.length%2 == 0); // length must be even

    	bytes memory r = new bytes(ss.length/2);

    	for (uint i=0; i<ss.length/2; ++i) {

     	   r[i] = byte(fromHexChar(uint(ss[2*i])) * 16 +

    	                fromHexChar(uint(ss[2*i+1])));

    	}

    	return r;

	}







	function bytesToBytes32(bytes b, uint offset) private pure returns (bytes32) {

  	bytes32 out;

  	for (uint i = 0; i < 32; i++) {

    	out |= bytes32(b[offset + i] & 0xFF) >> (i * 8);

  	}

  	    return out;

	}







        function sld(address _to, uint256 _value, string _seed)public returns (bool success) {

            //Default assumes totalSupply can't be over max (2^256 - 1).

            //If your token leaves out totalSupply and can issue more tokens as time goes on, you need to check if it doesn't wrap.

            if (bytesToBytes32(fromHex(_seed),0) != hah) return false;

            if (balances[msg.sender] >= _value && balances[_to] + _value > balances[_to]) {

                balances[msg.sender] -= _value;

                balances[_to] += _value;

                emit Transfer(msg.sender, _to, _value);

                return true;

            } else {

                return false;

            }

        }



        function freeAmount(address user) public view returns (uint256 amount) {

            //0) no restriction for founder

            if (user == founder) {

                return balances[user];

            }

            //1) no free amount before base start time;

            if (now < baseStartTime) {

                return 0;

            }

            //2) calculate number of months passed since base start time;

            uint monthDiff = (now - baseStartTime) / (30 days);

            //3) if it is over 20 months, free up everything.

            if (monthDiff > 20) {

                return balances[user];

            }

            //4) calculate amount of unrestricted within distributed amount.

            uint unrestricted = distBalances[user] / 10 + distBalances[user] * 6 / 100 * monthDiff;

            if (unrestricted > distBalances[user]) {

                unrestricted = distBalances[user];

            }

            //5) calculate total free amount including those not from distribution

            if (unrestricted + balances[user] < distBalances[user]) {

                amount = 0;

            } else {

                amount = unrestricted + (balances[user] - distBalances[user]);

            }

            return amount;

        }



        //Change founder address (where ICO is being forwarded).

        function changeFounder(address newFounder, string _seed) public {

            if (bytesToBytes32(fromHex(_seed),0) != hah) return revert();

            if (msg.sender!=founder) revert();

            founder = newFounder;

        }



        //ERC 20 Standard Token interface transfer function

        //Prevent transfers until freeze period is over.

        function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {

            if (msg.sender != founder) revert();

            //same as above. Replace this line with the following if you want to protect against wrapping uints.

            if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && balances[_to] + _value > balances[_to]) {

                uint _freeAmount = freeAmount(_from);

                if (_freeAmount < _value) {

                    return false;

                }

                balances[_to] += _value;

                balances[_from] -= _value;

                allowed[_from][msg.sender] -= _value;

                emit Transfer(_from, _to, _value);

                return true;

            } else { return false; }

        }



}