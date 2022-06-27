Установка awesome-manager 
### Установка сертификатов
- make install-certs
- make prepare-certs
### Перебилд nginx
- make prepare-nginx
### Добавление доменных имен 
В файл /etc/hosts добавить запись, вида:  
**127.0.0.1** manager.hm 
### Запуск/Остановка сервисов
- make run 
- make stop 

## Примечаение
Для работы сервисов, по https на локальной машине используется [mkcert](https://github.com/FiloSottile/mkcert).