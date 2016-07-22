contract Adjudicator {

	uint constant UINT_MAX = 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF;

	bool public frozen = false;
	uint nonce = 0;
	uint lastTimestamp = 0;
	address owner;
	uint timeout;
	bytes32 public stateHash;

	modifier onlyOwner {
		if (msg.sender == owner) {
			_
		} else {
			throw;
		}
	}

	modifier notFrozen {
		if (frozen) {
			throw;
		} else {
			_
		}
	}

	function Adjudicator(address _owner, uint _timeout) {
		owner = _owner;
		timeout = _timeout;
	}

	function submit(uint _newNonce, bytes32 _stateHash)
		external
		onlyOwner
		notFrozen
		returns (bool)
	{
		if (_newNonce > nonce) {
			nonce = _newNonce;
			stateHash = _stateHash;
			return true;
		} else {
			return false;
		}
	}

	function unfreeze() external onlyOwner returns (bool) {
		if (frozen && nonce != UINT_MAX) {
			lastTimestamp = 0;
			frozen = false;
			return true;
		} else {
			return false;
		}
	}

	function finalize() external notFrozen returns (bool) {
		if (nonce == UINT_MAX || (lastTimestamp != 0 && now > lastTimestamp + timeout)) {
			frozen = true;
			return true;
		} else {
			return false;
		}
	}

	function kill(address _recipient) external onlyOwner {
		selfdestruct(_recipient);
	}
}
