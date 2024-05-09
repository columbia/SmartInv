pragma solidity ^0.5.16;

contract Ownable
{
    address public owner;

    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

    constructor() public {
        owner = msg.sender;
    }

    modifier onlyOwner() {
        require(msg.sender == owner);
        _;
    }

    function transferOwnership(address newOwner) public onlyOwner {
        require(newOwner != address(0));
        emit OwnershipTransferred(owner, newOwner);
        owner = newOwner;
    }
}

contract TokenERC20 is Ownable {
    bytes32 public standard;
    bytes32 public name;
    bytes32 public symbol;
    uint256 public totalSupply;
    uint8 public decimals;
    bool public allowTransactions;
    mapping (address => uint256) public balanceOf;
    mapping (address => mapping (address => uint256)) public allowance;
    function transfer(address _to, uint256 _value) public;
    function approve(address _spender, uint256 _value) public;
    function transferFrom(address _from, address _to, uint256 _value) public;
}

library ECRecovery {

  /**
   * @dev Recover signer address from a message by using his signature
   * @param hash bytes32 message, the hash is the signed message. What is recovered is the signer address.
   * @param sig bytes signature, the signature is generated using web3.eth.sign()
   */
  function recover(bytes32 hash, bytes memory sig) internal pure returns (address) {
    bytes32 r;
    bytes32 s;
    uint8 v;

    //Check the signature length
    if (sig.length != 65) {
      return (address(0));
    }
    
    // Divide the signature in r, s and v variables
    assembly {
      r := mload(add(sig, 32))
      s := mload(add(sig, 64))
      v := byte(0, mload(add(sig, 96)))
    }

    // Version of signature should be 27 or 28, but 0 and 1 are also possible versions
    if (v < 27) {
      v += 27;
    }

    // If the version is correct return the signer address
    if (v != 27 && v != 28) {
      return (address(0));
    } else {
      return ecrecover(hash, v, r, s);
    }
  }

}

contract StmWalletSwap is Ownable {
    using ECRecovery for bytes32;
    
    mapping(bytes32 => bool) public swapList;
    
    event Swap(address _recipient, bytes32 _tradeID, address _cFrom, address _cOut, uint256 _vFrom, uint256 _vOut);
    event SwapAltChain(address _recipient, bytes32 _tradeID, address _cFrom, uint256 _vFrom);
    event TransferAltChain(bytes32 _tradeID, address _to, address _token, uint256 _amount);
    event AddEth(uint256 _amount);
    
   /**
    * _tradeID   - swap ID
    * _cFrom     - coin from
    * _cOut      - coin out
    * _vFrom     - value from
    * _vOut      - value out
    * _time      - max live time
    * _sign      - keccak256
    **/ 
    function swap(bytes32 _tradeID, address _cFrom, address _cOut, uint256 _vFrom, uint256 _vOut, uint256 _time, bytes calldata _sign) payable external 
    {
        require(_cFrom != _cOut);
        bytes32 _hashSwap = keccak256(abi.encodePacked(_tradeID, _cFrom, _cOut, _vFrom, _vOut, _time));
        
        if(now > _time) {
            return;
        }
        
        verifySign(_hashSwap, _sign, _tradeID);
        swapList[_tradeID] = true;
        
        if (_cFrom == address(0x0)) {
            require(msg.value > 0);
            require(msg.value == _vFrom);
        } else {
            require(safeTransferFrom(_cFrom, msg.sender, address(this), _vFrom));
        }
        
        if (_cOut == address(0x0)) {
            msg.sender.transfer(_vOut);
        } else {
            require(safeTransfer(_cOut, msg.sender, _vOut));
        }
        
        emit Swap(msg.sender, _tradeID, _cFrom, _cOut, _vFrom, _vOut);
    }
    
    function verifySign(bytes32 _hashSwap, bytes memory _sign, bytes32 _tradeID) private view {
        require(_hashSwap.recover(_sign) == owner);
        require(!swapList[_tradeID]);
    }
    
    function withdraw(address payable _to, address _token, uint256 _amount) external onlyOwner {
        if (_token == address(0x0)) {
            _to.transfer(_amount);
        } else {
            TokenERC20(_token).transfer(_to, _amount);
        }
    }
    
    /**
    * _tradeID   - swap ID
    * _cFrom     - coin from
    * _vFrom     - value from
    * _time      - max live time
    * _sign      - keccak256
    **/ 
    function swapAltChain(bytes32 _tradeID, address _cFrom, uint256 _vFrom, uint256 _time, bytes calldata _sign) payable external 
    {
        bytes32 _hashSwap = keccak256(abi.encodePacked(_tradeID, _cFrom, _vFrom, _time));
        
        if(now > _time) {
            return;
        }
        
        verifySign(_hashSwap, _sign, _tradeID);
        swapList[_tradeID] = true;
        
        if (_cFrom == address(0x0)) {
            require(msg.value > 0);
            require(msg.value == _vFrom);
        } else {
            require(safeTransferFrom(_cFrom, msg.sender, address(this), _vFrom));
        }
        
        emit SwapAltChain(msg.sender, _tradeID, _cFrom, _vFrom);
    }
    
    function transferAltChain(bytes32 _tradeID, address payable _to, address _token, uint256 _amount) external onlyOwner {
        if (_token == address(0x0)) {
            _to.transfer(_amount);
        } else {
            TokenERC20(_token).transfer(_to, _amount);
        }
        emit TransferAltChain(_tradeID, _to, _token, _amount);
    }
    
    function addEth() payable external
    {
        emit AddEth(msg.value);
    }
    
    function safeTransfer(address token, address to , uint value) private returns (bool result) {
        TokenERC20(token).transfer(to,value);

        assembly {
            switch returndatasize()   
                case 0 {
                    result := not(0)
                }
                case 32 {
                    returndatacopy(0, 0, 32)
                    result := mload(0)
                }
                default {
                    revert(0, 0)
                }
        }
        require(result);
    }
    
    function safeTransferFrom(address token, address _from, address to, uint value) private returns (bool result) {
        TokenERC20(token).transferFrom(_from, to, value);

        assembly {
            switch returndatasize()   
                case 0 {
                    result := not(0)
                }
                case 32 {
                    returndatacopy(0, 0, 32) 
                    result := mload(0)
                }
                default {
                    revert(0, 0) 
                }
        }
        require(result);
    }
}