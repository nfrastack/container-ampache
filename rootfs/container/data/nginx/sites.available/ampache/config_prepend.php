<?php
// SPDX-FileCopyrightText: © 2026 Nfrastack <code@nfrastack.com>
//
// SPDX-License-Identifier: MIT
// If client sent host:port, make SERVER_PORT/SERVER_NAME match it (helps with container mapping)

    if (!empty($_SERVER['HTTP_HOST']) && strpos($_SERVER['HTTP_HOST'], ':') !== false) {
        list($host, $port) = explode(':', $_SERVER['HTTP_HOST'], 2);
        if (is_numeric($port)) {
            $_SERVER['SERVER_PORT'] = $port;
            $_SERVER['SERVER_NAME'] = $host;
        }
    }
?>
