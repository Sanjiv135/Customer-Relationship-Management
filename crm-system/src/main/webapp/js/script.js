document.addEventListener('DOMContentLoaded', function() {
    console.log('CRM System JS - DOM loaded');
    initializeCRM();
});


function initializeCRM() {
    console.log('Initializing CRM System...');
    
    try {
        setupAlerts();
        setupTooltips();
        setupSearchFunctionality();
        setupFormValidation();
        setupDataTables();
        initializeEnhancedFeatures();
        setupEventListeners();
        console.log('✓ CRM System initialized successfully');
    } catch (error) {
        console.error('Error initializing CRM:', error);
    }
}


function setupEventListeners() {
    console.log('Setting up event listeners...');
    
   
    const loginForm = document.getElementById('loginForm');
    if (loginForm) {
        loginForm.addEventListener('submit', function(e) {
            validateLoginForm(e);
        });
        console.log('✓ Login form listener added');
    } else {
        console.log('✗ Login form not found');
    }
    
  
    const logoutButtons = document.querySelectorAll('.logout-btn, [data-action="logout"]');
    logoutButtons.forEach(button => {
        button.addEventListener('click', function(e) {
            e.preventDefault();
            if (confirm('Are you sure you want to logout?')) {
                window.location.href = 'auth?action=logout';
            }
        });
    });
    
    
    const generatePasswordBtn = document.getElementById('generatePassword');
    if (generatePasswordBtn) {
        generatePasswordBtn.addEventListener('click', generatePassword);
        console.log('✓ Password generator listener added');
    }
    
    
    const changePasswordForm = document.getElementById('changePasswordForm');
    if (changePasswordForm) {
        changePasswordForm.addEventListener('submit', function(e) {
            validatePasswordChange(e);
        });
        console.log('✓ Change password form listener added');
    }
    
    
    const deleteButtons = document.querySelectorAll('.delete-btn, [data-action="delete"]');
    deleteButtons.forEach(button => {
        button.addEventListener('click', function(e) {
            e.preventDefault();
            const username = this.getAttribute('data-username') || 'this item';
            const url = this.getAttribute('data-url') || this.href;
            confirmDelete(username, url);
        });
    });
    
    console.log(`✓ ${logoutButtons.length} logout buttons, ${deleteButtons.length} delete buttons configured`);
}


function setupAlerts() {
    const alerts = document.querySelectorAll('.alert:not(.alert-permanent)');
    console.log(`Found ${alerts.length} auto-dismiss alerts`);
    
    alerts.forEach(function(alert) {
        setTimeout(function() {
            try {
                if (typeof bootstrap !== 'undefined' && bootstrap.Alert) {
                    new bootstrap.Alert(alert).close();
                } else {
                    alert.style.display = 'none';
                }
            } catch (e) {
                console.warn('Could not close alert:', e);
                alert.style.display = 'none';
            }
        }, 5000);
    });
}

function showAlert(message, type) {
    if (!type) type = 'success';
    var container = document.getElementById('alertContainer') || createAlertContainer();
    var alertId = 'alert-' + Date.now();
    container.innerHTML += 
        '<div id="' + alertId + '" class="alert alert-' + type + ' alert-dismissible fade show" role="alert">' +
            message +
            '<button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>' +
        '</div>';
    setTimeout(function() {
        var alertElement = document.getElementById(alertId);
        if (alertElement) {
            alertElement.remove();
        }
    }, 5000);
}

function createAlertContainer() {
    var container = document.createElement('div');
    container.id = 'alertContainer';
    container.className = 'position-fixed top-0 end-0 p-3';
    container.style.zIndex = '9999';
    document.body.appendChild(container);
    return container;
}


function generatePassword() {
    try {
        const length = 12;
        const charset = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789!@#$%^&*";
        let password = "";
        
        
        password += "ABCDEFGHIJKLMNOPQRSTUVWXYZ".charAt(Math.floor(Math.random() * 26));
        password += "abcdefghijklmnopqrstuvwxyz".charAt(Math.floor(Math.random() * 26));
        password += "0123456789".charAt(Math.floor(Math.random() * 10)); 
        password += "!@#$%^&*".charAt(Math.floor(Math.random() * 8)); 
        
        
        for (let i = 4; i < length; i++) {
            password += charset.charAt(Math.floor(Math.random() * charset.length));
        }
        
        
        password = password.split('').sort(function(){return 0.5-Math.random()}).join('');
        
        
        const passwordField = document.getElementById('password');
        if (passwordField) {
            passwordField.type = 'text';
            passwordField.value = password;
            
            
            showToast('Secure password generated!', 'success');
            
            
            setTimeout(() => {
                passwordField.type = 'password';
            }, 5000);
        } else {
            showToast('Password field not found', 'warning');
        }
    } catch (error) {
        console.error('Error generating password:', error);
        showToast('Error generating password', 'danger');
    }
}


function setupPasswordStrength() {
    const passwordField = document.getElementById('password');
    if (passwordField) {
        passwordField.addEventListener('input', function() {
            const password = this.value;
            const strengthIndicator = document.getElementById('passwordStrength');
            
            if (!strengthIndicator) {
                
                const indicator = document.createElement('div');
                indicator.id = 'passwordStrength';
                indicator.className = 'form-text';
                this.parentNode.appendChild(indicator);
            }
            
            const strength = calculatePasswordStrength(password);
            const indicator = document.getElementById('passwordStrength');
            if (indicator) {
                indicator.innerHTML = `Password strength: <span class="text-${strength.color}">${strength.text}</span>`;
            }
        });
    }
}

function calculatePasswordStrength(password) {
    let score = 0;
    
    if (password.length >= 8) score++;
    if (password.match(/[a-z]/)) score++;
    if (password.match(/[A-Z]/)) score++;
    if (password.match(/[0-9]/)) score++;
    if (password.match(/[^a-zA-Z0-9]/)) score++;
    
    const levels = [
        { text: 'Very Weak', color: 'danger' },
        { text: 'Weak', color: 'danger' },
        { text: 'Fair', color: 'warning' },
        { text: 'Good', color: 'info' },
        { text: 'Strong', color: 'success' },
        { text: 'Very Strong', color: 'success' }
    ];
    
    return levels[Math.min(score, levels.length - 1)];
}


function showToast(message, type) {
    try {
        var toastContainer = document.getElementById('toastContainer');
        if (!toastContainer) {
            toastContainer = createToastContainer();
        }
        
        var toast = document.createElement('div');
        toast.className = 'alert alert-' + type + ' alert-dismissible fade show';
        
        
        var iconClass = 'fa-exclamation-triangle';
        if (type === 'success') {
            iconClass = 'fa-check-circle';
        }
        
        toast.innerHTML = 
            '<i class="fas ' + iconClass + '"></i> ' + message +
            '<button type="button" class="btn-close" data-bs-dismiss="alert"></button>';
        
        toastContainer.appendChild(toast);
        
        
        setTimeout(function() {
            if (toast.parentNode) {
                toast.remove();
            }
        }, 5000);
    } catch (error) {
        console.error('Error showing toast:', error);
       
        alert(message);
    }
}

function createToastContainer() {
    var container = document.createElement('div');
    container.id = 'toastContainer';
    container.className = 'position-fixed top-0 end-0 p-3';
    container.style.zIndex = '1055';
    document.body.appendChild(container);
    return container;
}


function confirmDelete(username, url) {
    if (confirm('Are you sure you want to delete ' + username + '? This action cannot be undone.')) {
        window.location.href = url;
    }
    return false;
}


function handleUrlParameters() {
    try {
        var urlParams = new URLSearchParams(window.location.search);
        var successParam = urlParams.get('success');
        var errorParam = urlParams.get('error');
        
        if (successParam) {
            showToast(decodeURIComponent(successParam), 'success');
            cleanUrlParameter('success');
        }
        
        if (errorParam) {
            showToast(decodeURIComponent(errorParam), 'danger');
            cleanUrlParameter('error');
        }
    } catch (error) {
        console.error('Error handling URL parameters:', error);
    }
}

function cleanUrlParameter(paramName) {
    try {
        var newUrl = window.location.pathname;
        var searchParams = new URLSearchParams(window.location.search);
        searchParams.delete(paramName);
        
        var newSearch = searchParams.toString();
        if (newSearch) {
            newUrl += '?' + newSearch;
        }
        
        window.history.replaceState({}, document.title, newUrl);
    } catch (error) {
        console.error('Error cleaning URL parameter:', error);
    }
}


function setupDataTables() {
    var tables = document.querySelectorAll('table.table');
    console.log(`Found ${tables.length} tables to enhance`);
    
    tables.forEach(function(table) {
        if (table.rows.length > 1) {
            table.classList.add('table-hover', 'table-striped');
        }
    });
}


function setupSearchFunctionality() {
    var searchInputs = document.querySelectorAll('input[type="search"]');
    console.log(`Found ${searchInputs.length} search inputs`);
    
    searchInputs.forEach(function(input) {
        input.addEventListener('input', debounce(function(e) {
            var searchTerm = e.target.value.toLowerCase();
            var table = findParentTable(e.target);
            
            if (table) {
                filterTableRows(table, searchTerm);
            }
        }, 300));
    });
}

function findParentTable(element) {
    var table = element.closest('.table-responsive');
    if (table) {
        table = table.querySelector('table');
    }
    if (!table) {
        table = element.closest('.card-body');
        if (table) {
            table = table.querySelector('table');
        }
    }
    if (!table) {
        table = document.querySelector('table');
    }
    return table;
}

function filterTableRows(table, searchTerm) {
    var rows = table.querySelectorAll('tbody tr');
    var visibleCount = 0;
    
    rows.forEach(function(row) {
        var text = row.textContent.toLowerCase();
        if (text.includes(searchTerm)) {
            row.style.display = '';
            visibleCount++;
        } else {
            row.style.display = 'none';
        }
    });
    
    
    var noResults = table.parentNode.querySelector('.no-results');
    if (noResults) {
        noResults.style.display = visibleCount === 0 ? 'block' : 'none';
    }
}


function setupFormValidation() {
    var forms = document.querySelectorAll('form:not(.no-validation)');
    console.log(`Found ${forms.length} forms for validation`);
    
    forms.forEach(function(form) {
        form.addEventListener('submit', function(e) {
            if (!form.checkValidity()) {
                e.preventDefault();
                e.stopPropagation();
            }
            form.classList.add('was-validated');
        });
    });
}


function validateLoginForm(e) {
    const username = document.getElementById('username');
    const password = document.getElementById('password');
    const role = document.getElementById('role');
    
    if (username && password && role) {
        if (!username.value.trim()) {
            e.preventDefault();
            showToast('Please enter username', 'warning');
            username.focus();
            return false;
        }
        if (!password.value.trim()) {
            e.preventDefault();
            showToast('Please enter password', 'warning');
            password.focus();
            return false;
        }
    }
    return true;
}

function validatePasswordChange(e) {
    const newPassword = document.getElementById('newPassword');
    const confirmPassword = document.getElementById('confirmPassword');
    
    if (newPassword && confirmPassword) {
        if (newPassword.value !== confirmPassword.value) {
            e.preventDefault();
            showToast('Passwords do not match', 'warning');
            confirmPassword.focus();
            return false;
        }
        if (newPassword.value.length < 6) {
            e.preventDefault();
            showToast('Password must be at least 6 characters long', 'warning');
            newPassword.focus();
            return false;
        }
    }
    return true;
}


function setupTooltips() {
    var tooltips = document.querySelectorAll('[data-bs-toggle="tooltip"]');
    console.log(`Found ${tooltips.length} tooltips`);
    
    if (typeof bootstrap !== 'undefined' && bootstrap.Tooltip) {
        tooltips.forEach(function(el) {
            new bootstrap.Tooltip(el);
        });
    }
}


function submitFormAjax(form) {
    showLoading();
    var formData = new FormData(form);
    
    fetch(form.action, {
        method: form.method,
        body: formData
    })
    .then(function(response) {
        if (response.ok) {
            return response.json();
        } else {
            throw new Error('Server error: ' + response.status);
        }
    })
    .then(function(result) {
        if (result.success) {
            showToast(result.message || 'Form submitted successfully', 'success');
            setTimeout(function() {
                if (result.redirect) {
                    window.location.href = result.redirect;
                } else {
                    window.location.reload();
                }
            }, 1500);
        } else {
            throw new Error(result.message || 'Form submission failed');
        }
    })
    .catch(function(error) {
        console.error('Form submission error:', error);
        showToast(error.message || 'An error occurred while submitting the form', 'danger');
    })
    .finally(function() {
        hideLoading();
    });
}


function showLoading() {
    var spinner = document.getElementById('loadingSpinner');
    if (!spinner) {
        spinner = createLoadingSpinner();
    }
    spinner.style.display = 'block';
}

function hideLoading() { 
    var spinner = document.getElementById('loadingSpinner');
    if (spinner) {
        spinner.style.display = 'none';
    }
}

function createLoadingSpinner() {
    var div = document.createElement('div');
    div.id = 'loadingSpinner';
    div.className = 'loading-spinner';
    div.innerHTML = '<div class="spinner-border text-primary" role="status"><span class="visually-hidden">Loading...</span></div><div class="mt-2 text-muted">Processing...</div>';
    div.style.position = 'fixed';
    div.style.top = '50%';
    div.style.left = '50%';
    div.style.transform = 'translate(-50%, -50%)';
    div.style.zIndex = '9999';
    div.style.display = 'none';
    div.style.background = 'rgba(255, 255, 255, 0.9)';
    div.style.padding = '20px';
    div.style.borderRadius = '8px';
    div.style.boxShadow = '0 4px 6px rgba(0, 0, 0, 0.1)';
    div.style.textAlign = 'center';
    document.body.appendChild(div);
    return div;
}

function getBasePath() { 
    
    if (typeof contextPath !== 'undefined') {
        return contextPath;
    }
    
    var metaPath = document.querySelector('meta[name="context-path"]');
    if (metaPath) {
        return metaPath.getAttribute('content');
    }
    
  
    var path = window.location.pathname;
    var context = path.substring(0, path.indexOf('/', 1));
    return context || '';
}

function debounce(func, wait) { 
    var timeout; 
    return function() { 
        var args = arguments;
        clearTimeout(timeout); 
        timeout = setTimeout(function() {
            func.apply(null, args);
        }, wait); 
    }; 
}


function validatePassword(password) {
    var minLength = 6;
    if (password.length < minLength) {
        return { valid: false, message: 'Password must be at least ' + minLength + ' characters long' };
    }
    return { valid: true, message: 'Password is strong enough' };
}

function setupPasswordValidation() {
    var passwordInputs = document.querySelectorAll('input[type="password"]');
    passwordInputs.forEach(function(input) {
        input.addEventListener('input', function() {
            var validation = validatePassword(this.value);
            var feedback = this.nextElementSibling;
            if (feedback && feedback.classList.contains('invalid-feedback')) {
                if (!validation.valid) {
                    this.classList.add('is-invalid');
                    this.classList.remove('is-valid');
                    feedback.textContent = validation.message;
                } else {
                    this.classList.remove('is-invalid');
                    this.classList.add('is-valid');
                    feedback.textContent = '';
                }
            }
        });
    });
}


function setupModalForms() {
  
    document.querySelectorAll('.modal').forEach(function(modal) {
        modal.addEventListener('hidden.bs.modal', function() {
            var forms = this.querySelectorAll('form');
            forms.forEach(function(form) {
                form.reset();
                form.classList.remove('was-validated');
            });
        });
    });
}


function setupEnhancedForms() {
    
    document.querySelectorAll('form').forEach(function(form) {
        form.addEventListener('submit', function(e) {
            var submitBtn = this.querySelector('button[type="submit"]');
            if (submitBtn) {
                var originalText = submitBtn.innerHTML;
                submitBtn.disabled = true;
                submitBtn.innerHTML = '<i class="fas fa-spinner fa-spin"></i> Processing...';
                
                
                setTimeout(function() {
                    submitBtn.disabled = false;
                    submitBtn.innerHTML = originalText;
                }, 5000);
            }
        });
    });
}


function initializeEnhancedFeatures() {
    setupPasswordStrength();
    setupPasswordValidation();
    setupModalForms();
    setupEnhancedForms();
    handleUrlParameters();
}


window.addEventListener('error', function(e) {
    console.error('Global JavaScript error:', e.error);
    console.error('Error details:', {
        message: e.message,
        filename: e.filename,
        lineno: e.lineno,
        colno: e.colno
    });
});


window.CRM = {
    showAlert: showAlert,
    showToast: showToast,
    showLoading: showLoading,
    hideLoading: hideLoading,
    validatePassword: validatePassword,
    submitFormAjax: submitFormAjax,
    confirmDelete: confirmDelete,
    handleUrlParameters: handleUrlParameters,
    generatePassword: generatePassword
};


if (document.readyState === 'loading') {
    document.addEventListener('DOMContentLoaded', initializeCRM);
} else {
  
    setTimeout(initializeCRM, 100);
}

console.log('CRM System JavaScript loaded successfully');