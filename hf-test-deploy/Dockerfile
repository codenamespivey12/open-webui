# HuggingFace Spaces Dockerfile using your custom image
FROM sixtyoneeighty/open-webui-custom:latest

# HuggingFace Spaces configuration
ENV PORT=7860 \
    HOST=0.0.0.0 \
    ENV=prod

EXPOSE 7860

# Start the application
CMD ["bash", "/app/backend/start.sh"]