// SPDX-License-Identifier: Unlicensed

pragma solidity ^0.8.20;

contract Inscripigeons {

    error MaxSupplyReached();
    error InvalidValue();
    error RequestingTooMany();
    error TransferFailed();
    error OnlyOwner();
    error AlreadyClaimed();
    error InvalidSnapshotProof();

    event Mint(address indexed minter, uint256 indexed amount, uint256 startID);

    uint256 public TOTAL_SUPPLY = 0;
    uint256 public PRICE = 0.003 * 1 ether;
    uint256 public immutable MAX_SUPPLY = 4900;

    address OWNER;

    modifier onlyOwner() {
        if (msg.sender != OWNER) {
            revert OnlyOwner();
        }
        _;
    }

    constructor () {
        OWNER = msg.sender;
    }

    function setPrice(uint256 _PRICE) external onlyOwner {
        PRICE = _PRICE;
    }

    function mint(uint256 amount) external payable {
        if (TOTAL_SUPPLY == MAX_SUPPLY) { revert MaxSupplyReached(); }
        if ((TOTAL_SUPPLY + amount) > MAX_SUPPLY) { revert RequestingTooMany(); }
        if ((PRICE * amount) != msg.value) { revert InvalidValue(); }
        

        (bool success,) = address(OWNER).call{value: msg.value}("");
        if (!success) {
            revert TransferFailed();
        }

        emit Mint(msg.sender, amount, TOTAL_SUPPLY);
        
        unchecked {
            TOTAL_SUPPLY += amount;
        }
    }

    function withdraw() external onlyOwner {
        (bool success,) = address(OWNER).call{value: address(this).balance}("");
        if (!success) {
            revert TransferFailed();
        }
    }
}