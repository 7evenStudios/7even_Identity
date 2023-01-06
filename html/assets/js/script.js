const config = {
  minAge: 12,
  maxAge: 100,
  minSize: 150,
  maxSize: 200,
}

const nameMatchesRegex = function (e) {
  return e.replace(/[^a-zA-Z0-9]/g, '');
}

const nameKeyup = function () {
  const value = $(this).val();
  const result = nameMatchesRegex(value);
  $(this).val(result);
}

const birthdateValidator = function (birthdate) {
  try {
    const date = new Date(birthdate);
    const age = new Date().getFullYear() - date.getFullYear();
    return age >= config.minAge && age <= config.maxAge;
  } catch (error) {
    throw new Error('Birthdate is not valid');
  }
}

const sizeValidator = function (size) {
  return size >= config.minSize && size <= config.maxSize;
}

let isFormShaking = false;
const shakeForm = function () {
  if (isFormShaking) return;
  isFormShaking = true;

  $('#form').addClass('animate__headShake');
  setTimeout(function () {
    isFormShaking = false;
    $('#form').removeClass('animate__headShake');
  }, 1000);
}

const emitClient = async (event, data) => {
  let url = `https://${GetParentResourceName()}/${event}`;
  let response = await fetch(url, {
    method: 'POST',
    headers: {
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: JSON.stringify(data)
  }).then(resp => resp.json()).catch(err => err);

  return response || {};
}

const wait = function (ms) {
  return new Promise(resolve => setTimeout(resolve, ms));
}

$(document).ready(function () {
  $('body').hide();

  $('#sizeLabel').append(` (${config.minSize} - ${config.maxSize})`);
  $('#size').attr('placeholder', `${config.minSize}`)


  $('#firstname').keyup(nameKeyup);
  $('#lastname').keyup(nameKeyup);

  $('#genderF').click(function () {
    $('#genderLabel').text("Female"); // can be edited
    $('#genderM').removeClass('selected');
    $(this).addClass('selected');
  });

  $('#genderM').click(function () {
    $('#genderLabel').text("Male"); // can be edited
    $('#genderF').removeClass('selected');
    $(this).addClass('selected');
  });

  $('#submitBtn').click(async function () {
    if ($(this).attr('disabled')) return;

    const firstname = $('#firstname').val();
    const lastname = $('#lastname').val();
    const birthdate = $('#birthdate').val();
    const gender = $('#genderF').hasClass('selected') ? 'f' : 'm';
    const size = $('#size').val() * 1;

    try {
      if (!firstname || !firstname.startsWith(firstname[0].toUpperCase())) throw new Error('Firstname is not valid');
      if (!lastname || !lastname.startsWith(lastname[0].toUpperCase())) throw new Error('Lastname is not valid');
      if (!birthdate || !birthdateValidator(birthdate)) throw new Error('Birthdate is not valid');
      if (!size || !sizeValidator(size)) throw new Error('Size is not valid');

      $('#submitBtn').attr('disabled', true);
      $('#submitBtn').addClass('green');
      $('#form').addClass('animate__pulse');
      $('#submitLabel').text('CREATING...');

      await wait(500);
      $('body').fadeOut(500);

      await wait(500);
      $('#form').removeClass('animate__pulse');

      emitClient('createCharacter', {
        firstname,
        lastname,
        dateofbirth: birthdate.replaceAll('-', '/'),
        gender,
        size
      });
    } catch (error) {
      shakeForm();

      $('#submitBtn').attr('disabled', true);
      $('#submitLabel').text(error.message);

      await wait(1000);
      $('#submitBtn').attr('disabled', false);
      $('#submitLabel').text('CREATE');
    }
  });

  window.addEventListener('message', function (event) {
    if (event.data.type === 'open') {
      $('body').fadeIn(500);
    }
  });
});