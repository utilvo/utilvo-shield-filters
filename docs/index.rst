utilvo-shield-filters Documentation
===================================

Zero-dependency multi-language parser and domain suffix matcher for Adblock Plus 2.0 (``[Adblock Plus 2.0]``) and uBlock Origin static network filter rules.

Overview
--------

``utilvo-shield-filters`` parses standard ``||domain^$third-party,domain=~example.com`` network rules, extracts normalized lowercase target hostnames, ``$third-party`` modifiers, and excluded context domains, and provides fast parent-domain suffix matching against domain blocklists.

- **Official Documentation & Homepage:** `https://utilvo.com/shield <https://utilvo.com/shield>`_
- **Filter List Endpoint:** `https://utilvo.com/filters/utilvo-shield-filters.txt <https://utilvo.com/filters/utilvo-shield-filters.txt>`_
- **Source Repository:** `https://github.com/utilvo/utilvo-shield-filters <https://github.com/utilvo/utilvo-shield-filters>`_

Installation
------------

Node.js (npm)
~~~~~~~~~~~~~

.. code-block:: bash

   npm install utilvo-shield-filters

Python (PyPI)
~~~~~~~~~~~~~

.. code-block:: bash

   pip install utilvo-shield-filters

Go Module
~~~~~~~~~

.. code-block:: bash

   go get github.com/utilvo/utilvo-shield-filters@latest

Rust (Crates.io)
~~~~~~~~~~~~~~~~

.. code-block:: bash

   cargo add utilvo-shield-filters

.NET / C# (NuGet)
~~~~~~~~~~~~~~~~~

.. code-block:: bash

   dotnet add package Utilvo.Shield.Filters

PHP (Composer / Packagist)
~~~~~~~~~~~~~~~~~~~~~~~~~~

.. code-block:: bash

   composer require utilvo/utilvo-shield-filters

Ruby (RubyGems)
~~~~~~~~~~~~~~~

.. code-block:: bash

   gem install utilvo-shield-filters

Elixir (Hex.pm)
~~~~~~~~~~~~~~~

.. code-block:: elixir

   {:utilvo_shield_filters, "~> 1.0"}

API Reference
-------------

``parseAbpRule(line)`` / ``parse_abp_rule(line)``
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Parses a single ABP 2.0 network rule line and returns the normalized lowercase domain, ``thirdParty`` boolean flag, and ``excludedDomains`` list. Returns ``null`` / ``None`` for comments (``!``), headers (``[Adblock Plus 2.0]``), or cosmetic rules.

``isHostBlocked(hostname, blockedSet)`` / ``is_host_blocked(hostname, blocked_set)``
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Checks whether ``hostname`` or any of its parent registrable domain suffixes exist in ``blockedSet``.

License
-------

Code is licensed under the MIT License. Filter list rules are licensed under CC BY-SA 4.0.
